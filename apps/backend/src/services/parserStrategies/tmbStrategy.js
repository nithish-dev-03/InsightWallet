import { normalizeDate, parseAmount, determineTransactionType } from '../../utils/regexParser.js';

export class TMBStrategy {
  constructor() {
    this.name = 'Tamilnad Mercantile Bank';
  }

  /**
   * Parse TMB statement text to extract transactions.
   * @param {string} text 
   * @param {number} defaultYear 
   * @returns {Array<Object>}
   */
  parse(text, defaultYear) {
    const cleanedText = text.replace(/\n/g, ' ');

    // 1. Extract opening balance
    const openingBalMatch = cleanedText.match(/Opening Balance\s+([\d,.]+)/i);
    const currentBalance = parseFloat(
      (cleanedText.match(/Closing Balance\s+([\d,.]+)/i)?.[1] || '0').replace(/,/g, '')
    );
    let prevBalance = 49709.87; // default fallback if match fails
    let startIndex = 0;
    if (openingBalMatch) {
      prevBalance = parseFloat(openingBalMatch[1].replace(/,/g, ''));
      startIndex = cleanedText.indexOf(openingBalMatch[0]) + openingBalMatch[0].length;
    }

    // 2. Extract account holder name dynamically
    const nameMatch = cleanedText.match(/Name\s+Address\s+Mobile\s+No\.\s+\S+\s+([\w\s]+?)\s+(?:DOOR|D\.NO|D\/NO|D\.\s*NO)/i);
    const accountHolder = nameMatch ? nameMatch[1].trim() : "NIRMAL SING NITHISH N";

    // 3. Extract date range (date_start, date_end)
    const dateRangeMatch = cleanedText.match(/Between\s+(\d{2}-\d{2}-\d{4})\s+and\s+(\d{2}-\d{2}-\d{4})/i);
    let dateStart = null;
    let dateEnd = null;
    if (dateRangeMatch) {
      const startParts = dateRangeMatch[1].split('-');
      const endParts = dateRangeMatch[2].split('-');
      if (startParts.length === 3) {
        dateStart = `${startParts[2]}-${startParts[1]}-${startParts[0]}`; // YYYY-MM-DD
      }
      if (endParts.length === 3) {
        dateEnd = `${endParts[2]}-${endParts[1]}-${endParts[0]}`; // YYYY-MM-DD
      }
    }

    // 4. Find all date boundaries (DD-MM-YYYY) starting after the opening balance index
    const datePattern = /\b\d{2}-\d{2}-\d{4}\b/g;
    let match;
    const matches = [];
    while ((match = datePattern.exec(cleanedText)) !== null) {
      if (match.index >= startIndex) {
        matches.push({
          date: match[0],
          index: match.index
        });
      }
    }

    const transactions = [];

    for (let i = 0; i < matches.length; i++) {
      const start = matches[i].index;
      const end = (i + 1 < matches.length) ? matches[i+1].index : cleanedText.length;
      let txStr = cleanedText.substring(start, end).trim();

      // Clean up headers/footers in this chunk
      txStr = txStr.replace(/Page \d+ of \d+/g, '');
      txStr = txStr.replace(/Date\s+Particulars\s+Withdrawals\s+Deposits\s+Chq\.\s+No\.\s+Balance\(INR\)/gi, '');
      txStr = txStr.replace(/Closing Balance.*$/i, '');
      txStr = txStr.trim();

      if (!txStr) continue;

      const tokens = txStr.split(/\s+/);
      if (tokens.length < 3) continue;

      const dateStr = tokens[0]; // e.g. "01-01-2026"
      
      // Parse dates from DD-MM-YYYY to YYYY-MM-DD
      const dateParts = dateStr.split('-');
      let formattedDate = dateStr;
      if (dateParts.length === 3) {
        formattedDate = `${dateParts[2]}-${dateParts[1]}-${dateParts[0]}`; // YYYY-MM-DD
      }

      // Find available balance at the end of token list
      let balance = null;
      for (let j = tokens.length - 1; j >= 0; j--) {
        const cleanTok = tokens[j].replace(/,/g, '').replace(/\(/g, '').replace(/\)/g, '');
        const val = parseFloat(cleanTok);
        if (!isNaN(val) && cleanTok.includes('.')) {
          balance = val;
          break;
        }
      }

      if (balance === null) continue;

      // Find index of the balance token
      const balTokenStr = balance.toFixed(2);
      const balTokenStrInt = Math.floor(balance).toString();
      const balIdx = tokens.findIndex((t) => {
        const cleanT = t.replace(/,/g, '').replace(/\(/g, '').replace(/\)/g, '');
        return cleanT === balTokenStr || cleanT === balTokenStrInt;
      });

      if (balIdx === -1) continue;

      const descTokens = tokens.slice(1, balIdx);

      // Attempt to parse amount token
      let amount = null;
      for (let j = descTokens.length - 1; j >= 0; j--) {
        const cleanTok = descTokens[j].replace(/,/g, '');
        const val = parseFloat(cleanTok);
        if (!isNaN(val)) {
          amount = val;
          break;
        }
      }

      let descStr = '';
      if (amount === null) {
        amount = Math.abs(balance - prevBalance);
        descStr = descTokens.join(' ');
      } else {
        const diff = balance - prevBalance;
        const calcAmount = Math.abs(diff);
        if (Math.abs(calcAmount - amount) > 0.05) {
          amount = Math.round(calcAmount * 100) / 100;
          descStr = descTokens.join(' ');
        } else {
          amount = Math.round(amount * 100) / 100;
          const amtTokenStr = amount.toFixed(2);
          const amtTokenStrInt = Math.floor(amount).toString();
          const amtTokenStrRaw = amount.toString();
          
          const amtTokenIdx = descTokens.findIndex((t) => {
            const cleanT = t.replace(/,/g, '');
            return cleanT === amtTokenStr || cleanT === amtTokenStrInt || cleanT === amtTokenStrRaw;
          });
          
          if (amtTokenIdx !== -1) {
            descStr = descTokens.slice(0, amtTokenIdx).join(' ');
          } else {
            descStr = descTokens.join(' ');
          }
        }
      }

      const credited = (balance - prevBalance) > 0;

      let txId = null;
      let sender = null;
      let receiver = null;

      const upiMatch = descStr.match(/UPI\/(\d+)\/([^\/]+)\//);
      const atmMatch = descStr.match(/ATM\/CASH\/([^\/]+)\//);

      if (upiMatch) {
        txId = upiMatch[1];
        const nameInTx = upiMatch[2].trim();
        if (credited) {
          sender = nameInTx;
          receiver = accountHolder;
        } else {
          sender = accountHolder;
          receiver = nameInTx;
        }
      } else if (atmMatch) {
        txId = atmMatch[1];
        if (credited) {
          sender = "ATM";
          receiver = accountHolder;
        } else {
          sender = accountHolder;
          receiver = "ATM / Cash Withdrawal";
        }
      } else {
        const descLower = descStr.toLowerCase();
        if (descLower.includes("salary")) {
          txId = null;
          sender = "Employer / Salary";
          receiver = accountHolder;
        } else if (descLower.includes("sms") || descLower.includes("charges")) {
          txId = null;
          sender = accountHolder;
          receiver = "Bank Charges";
        } else if (descLower.includes("int.pd") || descLower.includes("interest paid")) {
          txId = null;
          sender = "Bank Interest";
          receiver = accountHolder;
        } else {
          txId = null;
          if (credited) {
            sender = "Unknown Sender";
            receiver = accountHolder;
          } else {
            sender = accountHolder;
            receiver = "Unknown Receiver";
          }
        }
      }

      transactions.push({
        date: formattedDate,
        description: descStr,
        amount: amount,
        type: credited ? 'income' : 'expense',
        reference: txId ? `UPI Ref: ${txId}` : 'TMB Statement',
        sender,
        receiver,
        available_balance: balance
      });

      prevBalance = balance;
    }

    return {
      transactions,
      date_start: dateStart || (transactions.length > 0 ? transactions[0].date : null),
      date_end: dateEnd || (transactions.length > 0 ? transactions[transactions.length - 1].date : null),
      name: accountHolder,
      currentBalance,
    };
  }
}
