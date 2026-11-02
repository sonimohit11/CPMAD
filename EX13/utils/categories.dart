/// Single source of truth for transaction categories.
const expenseCategories = <String>[
  'Food', 'Travel', 'Shopping', 'Bills', 'Health', 'Education',
  'Entertainment', 'Rent', 'Utilities', 'Personal care', 'Other',
];

const incomeCategories = <String>[
  'Salary', 'Freelance', 'Business', 'Investment', 'Gift',
  'Interest', 'Refund', 'Rental income', 'Other',
];

/// Every distinct category, used by the filter dropdown.
final allCategories = <String>{...expenseCategories, ...incomeCategories}.toList();
