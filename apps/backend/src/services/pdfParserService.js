import { ChaseStrategy } from './parserStrategies/chaseStrategy.js';
import { WellsFargoStrategy } from './parserStrategies/wellsFargoStrategy.js';
import { TMBStrategy } from './parserStrategies/tmbStrategy.js';
import { GenericStrategy } from './parserStrategies/genericStrategy.js';
import { extractStatementYear } from '../utils/regexParser.js';

/**
 * Service responsible for resolving the appropriate parsing strategy
 * and executing it against the extracted text.
 */
export const parseStatement = async (text) => {
  if (!text) {
    throw new Error('No text extracted from PDF statement');
  }

  // 1. Print the extracted text to the console
  // console.log('--- EXTRACTED PDF TEXT START ---');
  // console.log(text);
  // console.log('--- EXTRACTED PDF TEXT END ---');

  // 2. Identify the bank type
  let strategy;
  const textUpper = text.toUpperCase();

  if (textUpper.includes('CHASE')) {
    strategy = new ChaseStrategy();
  } else if (textUpper.includes('WELLS FARGO')) {
    strategy = new WellsFargoStrategy();
  } else if (textUpper.includes('TMBL') || textUpper.includes('TAMILNAD MERCANTILE') || textUpper.includes('SATHANKULAM')) {
    strategy = new TMBStrategy();
  } else {
    strategy = new GenericStrategy();
  }

  // console.log(`Identified parsing strategy: ${strategy.name}`);

  // 3. Extract statement year for date resolution
  const statementYear = extractStatementYear(text);
  // console.log(`Extracted/Assumed Statement Year: ${statementYear}`);

  // 4. Parse transactions using strategy
  const parseResult = strategy.parse(text, statementYear);
  const transactions = Array.isArray(parseResult) ? parseResult : parseResult.transactions;
  const date_start = Array.isArray(parseResult) ? null : parseResult.date_start;
  const date_end = Array.isArray(parseResult) ? null : parseResult.date_end;
  const name = Array.isArray(parseResult) ? null : parseResult.name;

  // 5. Print the parsed transaction table to the console
  // console.log('--- PARSED TRANSACTIONS TABLE ---');
  // console.table(transactions);
  // console.log(`Total transactions parsed: ${transactions.length}`);

  return {
    bank: strategy.name,
    year: statementYear,
    transactions,
    date_start,
    date_end,
    name,
  };
};

export default {
  parseStatement,
};
