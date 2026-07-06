import { normalizeDate, parseAmount, determineTransactionType } from '../../utils/regexParser.js';

export class ChaseStrategy {
  constructor() {
    this.name = 'Chase';
  }

  /**
   * Parse Chase statement text to extract transactions.
   * @param {string} text 
   * @param {number} defaultYear 
   * @returns {Array<Object>}
   */
  parse(text, defaultYear) {
    const transactions = [];
    const lines = text.split('\n');

    // Regex 1: Double date (e.g. "10/24 10/25 STARBUCKS 12.34" or "10/24 10/25 STARBUCKS -12.34")
    // Commonly found in Chase Credit Card statements.
    const doubleDateRegex = /^(\d{2}\/\d{2})\s+(\d{2}\/\d{2})\s+(.+?)\s+([-+]?\$?\d+(?:,\d{3})*\.\d{2})(?:\s+.*)?$/;

    // Regex 2: Single date (e.g. "10/24 STARBUCKS 12.34" or "10/24/2026 STARBUCKS $12.34")
    const singleDateRegex = /^(\d{2}\/\d{2}(?:\/\d{2,4})?)\s+(.+?)\s+([-+]?\$?\d+(?:,\d{3})*\.\d{2})(?:\s+.*)?$/;

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed) continue;

      // Try double date first
      let match = trimmed.match(doubleDateRegex);
      if (match) {
        const [_, txnDateStr, postDateStr, desc, amountStr] = match;
        const amount = parseAmount(amountStr);
        // Chase Credit Card statement: payments are shown with minus or credit, purchases are positive.
        // We use our helper but can also customize:
        const type = determineTransactionType(amount, desc);
        
        transactions.push({
          date: normalizeDate(txnDateStr, defaultYear),
          description: desc.trim(),
          amount: Math.abs(amount),
          type,
          reference: `Chase CC Post:${postDateStr}`
        });
        continue;
      }

      // Try single date
      match = trimmed.match(singleDateRegex);
      if (match) {
        const [_, dateStr, desc, amountStr] = match;
        const amount = parseAmount(amountStr);
        const type = determineTransactionType(amount, desc);

        transactions.push({
          date: normalizeDate(dateStr, defaultYear),
          description: desc.trim(),
          amount: Math.abs(amount),
          type,
          reference: 'Chase Statement'
        });
      }
    }

    return transactions;
  }
}
