/**
 * Helper utility for extracting and normalizing transaction data from text using regular expressions.
 */

// Month mappings for text-based dates
const MONTHS = {
  jan: '01', feb: '02', mar: '03', apr: '04', may: '05', jun: '06',
  jul: '07', aug: '08', sep: '09', oct: '10', nov: '11', dec: '12',
  january: '01', february: '02', march: '03', april: '04', june: '06',
  july: '07', august: '08', september: '09', october: '10', november: '11', december: '12'
};

// Keywords that strongly indicate income
const INCOME_KEYWORDS = [
  'deposit',
  'direct deposit',
  'payroll',
  'salary',
  'refund',
  'credit',
  'reversal',
  'interest paid',
  'interest earned',
  'transfer from',
  'ach deposit',
  'wire deposit'
];

// Keywords that strongly indicate expense
const EXPENSE_KEYWORDS = [
  'purchase',
  'payment',
  'withdrawal',
  'atm',
  'fee',
  'charge',
  'transfer to',
  'ach debit',
  'wire transfer to',
  'bill payment',
  'autopay'
];

/**
 * Clean and parse a numeric amount from a string.
 * Supports $, commas, negative signs, and trailing CR/DR.
 * @param {string} amountStr 
 * @returns {number}
 */
export const parseAmount = (amountStr) => {
  if (!amountStr) return 0;
  
  let cleaned = amountStr.trim().replace(/[\$,]/g, '');
  
  // Handle trailing CR/DR or minus signs
  let isNegative = false;
  if (cleaned.startsWith('-') || cleaned.endsWith('-')) {
    isNegative = true;
    cleaned = cleaned.replace('-', '');
  } else if (cleaned.toUpperCase().endsWith('DR')) {
    isNegative = true;
    cleaned = cleaned.replace(/DR/i, '');
  } else if (cleaned.toUpperCase().endsWith('CR')) {
    isNegative = false;
    cleaned = cleaned.replace(/CR/i, '');
  }

  const value = parseFloat(cleaned);
  return isNegative ? -Math.abs(value) : Math.abs(value);
};

/**
 * Extract a potential statement year from text.
 * Looks for patterns like "2024", "2025", "2026" etc.
 * @param {string} text 
 * @returns {number}
 */
export const extractStatementYear = (text) => {
  const currentYear = new Date().getFullYear();
  // Find all 4 digit numbers between 2000 and 2100
  const yearRegex = /\b(20\d{2})\b/g;
  const matches = [...text.matchAll(yearRegex)];
  
  if (matches.length > 0) {
    // Return the most frequent year or the highest one that is <= currentYear + 1
    const years = matches.map(m => parseInt(m[1], 10));
    const yearCounts = {};
    let maxCount = 0;
    let bestYear = currentYear;

    for (const yr of years) {
      if (yr > 2100) continue;
      yearCounts[yr] = (yearCounts[yr] || 0) + 1;
      if (yearCounts[yr] > maxCount) {
        maxCount = yearCounts[yr];
        bestYear = yr;
      }
    }
    return bestYear;
  }
  
  return currentYear;
};

/**
 * Normalize different date formats into YYYY-MM-DD.
 * Supports:
 * - MM/DD (e.g. 10/24)
 * - MM/DD/YYYY or MM/DD/YY (e.g. 10/24/2026 or 10/24/26)
 * - MMM DD (e.g. Oct 24)
 * - MMM DD, YYYY (e.g. Oct 24, 2026)
 * - YYYY-MM-DD
 * @param {string} dateStr 
 * @param {number} defaultYear 
 * @returns {string} YYYY-MM-DD or original if parsing fails
 */
export const normalizeDate = (dateStr, defaultYear = new Date().getFullYear()) => {
  if (!dateStr) return '';
  
  let cleanDate = dateStr.trim().replace(/\s+/g, ' ');

  // 1. Check YYYY-MM-DD
  if (/^\d{4}-\d{2}-\d{2}$/.test(cleanDate)) {
    return cleanDate;
  }

  // 2. Check MM/DD/YYYY or MM/DD/YY
  const slashDateMatch = cleanDate.match(/^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2,4})$/);
  if (slashDateMatch) {
    let [_, month, day, year] = slashDateMatch;
    month = month.padStart(2, '0');
    day = day.padStart(2, '0');
    if (year.length === 2) {
      year = `20${year}`; // Assume 20xx for 2-digit years
    }
    return `${year}-${month}-${day}`;
  }

  // 3. Check MM/DD
  const shortSlashMatch = cleanDate.match(/^(\d{1,2})[\/\-](\d{1,2})$/);
  if (shortSlashMatch) {
    let [_, month, day] = shortSlashMatch;
    month = month.padStart(2, '0');
    day = day.padStart(2, '0');
    return `${defaultYear}-${month}-${day}`;
  }

  // 4. Check MMM DD, YYYY or MMM DD
  const wordDateMatch = cleanDate.match(/^([A-Za-z]+)\s+(\d{1,2})(?:,?\s+(\d{4}))?$/);
  if (wordDateMatch) {
    let [_, monthStr, day, year] = wordDateMatch;
    const month = MONTHS[monthStr.toLowerCase()];
    if (month) {
      day = day.padStart(2, '0');
      const finalYear = year || defaultYear;
      return `${finalYear}-${month}-${day}`;
    }
  }

  return dateStr;
};

/**
 * Determine if a transaction is income or expense based on amount and description.
 * @param {number} amountParsed 
 * @param {string} description 
 * @returns {'income'|'expense'}
 */
export const determineTransactionType = (amountParsed, description) => {
  const descLower = description.toLowerCase();
  
  // Rule 1: Negative amount is usually an expense, positive is income
  // However, on some statements, sign can be reversed (e.g. credit card statements charge is positive, payments negative).
  // We check keywords to refine this.
  
  const hasIncomeKeyword = INCOME_KEYWORDS.some(k => descLower.includes(k));
  const hasExpenseKeyword = EXPENSE_KEYWORDS.some(k => descLower.includes(k));
  
  if (hasIncomeKeyword && !hasExpenseKeyword) {
    return 'income';
  }
  if (hasExpenseKeyword && !hasIncomeKeyword) {
    return 'expense';
  }
  
  // Fallback to sign
  return amountParsed >= 0 ? 'income' : 'expense';
};
