import { normalizeDate, parseAmount, determineTransactionType } from '../../utils/regexParser.js';

export class GenericStrategy {
  constructor() {
    this.name = 'Generic Fallback';
  }

  /**
   * Parse generic statement text using general heuristics.
   * @param {string} text 
   * @param {number} defaultYear 
   * @returns {Array<Object>}
   */
  parse(text, defaultYear) {
    const transactions = [];
    const lines = text.split('\n');

    // Generic transaction line matchers
    const patterns = [
      // 1. Standard MM/DD/YYYY or MM/DD/YY (e.g. 10/24/2026 or 10/24/26)
      /^(\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4})\s+(.+?)\s+([-+]?\$?\d+(?:,\d{3})*\.\d{2})(?:\s+.*)?$/,
      
      // 2. Short MM/DD (e.g. 10/24)
      /^(\d{1,2}[\/\-]\d{1,2})\s+(.+?)\s+([-+]?\$?\d+(?:,\d{3})*\.\d{2})(?:\s+.*)?$/,
      
      // 3. Word date (e.g. Oct 24, 2026 or Oct 24)
      /^([A-Za-z]{3,9}\s+\d{1,2}(?:,?\s+\d{4})?)\s+(.+?)\s+([-+]?\$?\d+(?:,\d{3})*\.\d{2})(?:\s+.*)?$/,
      
      // 4. ISO Date (e.g. 2026-10-24)
      /^(\d{4}[\/\-]\d{2}[\/\-]\d{2})\s+(.+?)\s+([-+]?\$?\d+(?:,\d{3})*\.\d{2})(?:\s+.*)?$/
    ];

    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed) continue;

      let matched = false;
      for (const pattern of patterns) {
        const match = trimmed.match(pattern);
        if (match) {
          const [_, dateStr, desc, amountStr] = match;

          // Skip headers or metadata
          const lowerDesc = desc.toLowerCase();
          if (
            lowerDesc.startsWith('statement') || 
            lowerDesc.startsWith('page') || 
            lowerDesc.startsWith('balance') || 
            lowerDesc.startsWith('summary')
          ) {
            continue;
          }

          const amount = parseAmount(amountStr);
          const type = determineTransactionType(amount, desc);

          transactions.push({
            date: normalizeDate(dateStr, defaultYear),
            description: desc.trim(),
            amount: Math.abs(amount),
            type,
            reference: 'Generic Statement Parse'
          });
          
          matched = true;
          break; // Stop checking other patterns for this line
        }
      }
    }

    return transactions;
  }
}
