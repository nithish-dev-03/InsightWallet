import { normalizeDate, parseAmount, determineTransactionType } from '../../utils/regexParser.js';

export class WellsFargoStrategy {
  constructor() {
    this.name = 'Wells Fargo';
  }

  /**
   * Parse Wells Fargo statement text to extract transactions.
   * @param {string} text 
   * @param {number} defaultYear 
   * @returns {Array<Object>}
   */
  parse(text, defaultYear) {
    const transactions = [];
    const lines = text.split('\n');

    // Wells Fargo dates can be:
    // 1. Slash dates: MM/DD or MM/DD/YYYY (e.g. "10/24", "10/24/2026")
    // 2. Word dates: MMM DD or MMMM DD (e.g. "Oct 24", "October 24")
    // Let's create a combined regex that matches:
    // - Group 1: Month/Day (slash or word format)
    // - Group 2: Description
    // - Group 3: Amount
    const wfRegex = /^((?:\d{2}\/\d{2}(?:\/\d{2,4})?)|(?:[A-Za-z]{3,9}\s+\d{1,2}))\s+(.+?)\s+([-+]?\$?\d+(?:,\d{3})*\.\d{2})(?:\s+.*)?$/;

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed) continue;

      const match = trimmed.match(wfRegex);
      if (match) {
        const [_, dateStr, desc, amountStr] = match;
        
        // Skip header lines that might match (e.g., "Statement Date October 31")
        if (desc.toLowerCase().startsWith('statement') || desc.toLowerCase().startsWith('page')) {
          continue;
        }

        const amount = parseAmount(amountStr);
        const type = determineTransactionType(amount, desc);

        transactions.push({
          date: normalizeDate(dateStr, defaultYear),
          description: desc.trim(),
          amount: Math.abs(amount),
          type,
          reference: 'Wells Fargo Statement'
        });
      }
    }

    return transactions;
  }
}
