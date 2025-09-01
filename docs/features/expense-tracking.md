# Expense Tracking Feature

## Overview
The Expense Tracking feature enables barbers and salon owners to record and categorize their business expenses. It provides a comprehensive system for managing expense categories, logging daily expenses, and tracking spending patterns over time.

## Key Components

### 1. Expense Categories (`ExpenseCategory`)
**Purpose**: Categorization system for organizing different types of business expenses.

**Key Properties**:
- `id`: Auto-incrementing unique identifier
- `name`: Category name (e.g., "Rent", "Supplies", "Utilities", "Marketing")
- `color`: ARGB color integer for visual identification
- `iconName`: Icon identifier for UI display
- `sortOrder`: Custom ordering for display
- `userId`: User isolation for multi-user support

**Important Implementation Details**:
- Color-coded categories for visual organization
- Icon support for intuitive category identification
- Custom sort order for personalized organization
- User-specific categories for data isolation

### 2. Expense Records (`Expense`)
**Purpose**: Individual expense entries with detailed information.

**Key Properties**:
- `id`: Auto-incrementing unique identifier
- `date`: Expense date (stored as DateTime)
- `categoryId`: Reference to expense category
- `amountMinor`: Expense amount in minor currency units (cents)
- `vendor`: Optional vendor/supplier name
- `note`: Optional additional notes
- `userId`: User isolation

**Important Implementation Details**:
- Amount stored in minor units to avoid floating-point precision issues
- Foreign key relationship with expense categories
- Optional vendor tracking for business record keeping
- Date-based organization for time-series analysis

## Backend Architecture

### Repository Pattern (`ExpenseRepository`)
**Purpose**: Handles all data operations for expense-related entities.

**Key Methods**:
- `getCategories(userId)`: Retrieves user's expense categories
- `upsertCategory(category)`: Creates or updates expense categories
- `deleteCategory(id)`: Removes expense categories
- `addExpense(expense)`: Creates new expense records
- `updateExpense(expense)`: Updates existing expense records
- `deleteExpense(id)`: Removes expense records
- `getExpensesForDateRange(start, end, userId)`: Retrieves expenses for specific periods

**Important Implementation Details**:
- Uses Isar database with optimized queries
- Implements stream-based real-time updates
- Date range queries with inclusive boundaries
- User isolation for multi-user support
- Automatic data change notifications

### State Management (`ExpenseCubit`)
**Purpose**: Manages application state for expense-related UI components.

**Key Methods**:
- `loadCategories(userId)`: Loads expense categories into state
- `upsertCategory(category)`: Manages category CRUD operations
- `addExpense(expense)`: Handles expense record creation
- `updateExpense(expense)`: Handles expense record updates
- `deleteExpense(id, userId)`: Handles expense record deletion
- `refreshRange(start, end, userId)`: Refreshes data for specific date ranges

**Important Implementation Details**:
- Uses BLoC pattern for predictable state management
- Automatic state updates after data operations
- Loading states for UI feedback
- Real-time total calculation for expense summaries

## User Interface

### Expenses Screen (`ExpensesScreen`)
**Purpose**: Main interface for expense entry and management.

**Key Features**:
- Category selection with visual indicators
- Amount input with currency formatting
- Date picker for expense date
- Vendor name input field
- Notes field for additional information
- Form validation and submission
- Expense list with edit/delete capabilities

**Important Implementation Details**:
- Color-coded category selection for visual clarity
- Real-time amount formatting with user's currency
- Form validation prevents invalid submissions
- Expansion tile interface for organized data entry
- Immediate UI updates after successful submissions

### Edit Expense Screen (`EditExpenseScreen`)
**Purpose**: Interface for modifying existing expense records.

**Key Features**:
- Pre-populated form with existing data
- Category modification capabilities
- Amount and date editing
- Vendor and notes editing
- Delete functionality
- Validation and error handling

## Data Flow

1. **Category Setup**: User creates expense categories with names, colors, and icons
2. **Expense Entry**: User selects category, enters amount, date, vendor, and notes
3. **Record Processing**: System stores expense in local database
4. **Real-time Updates**: UI updates immediately through BLoC state management
5. **Monthly Aggregation**: Dashboard and reports aggregate expense data

## Performance Optimizations

- **Indexed Queries**: Isar database indexes on `userId` and `date` for fast lookups
- **Stream-based Updates**: Real-time UI updates without full data refreshes
- **Minor Unit Storage**: Avoids floating-point precision issues
- **Date Range Optimization**: Efficient queries for monthly summaries
- **Cached Totals**: Automatic total calculation for expense summaries

## Error Handling

- **Validation**: Form validation prevents invalid data entry
- **Database Transactions**: Atomic operations ensure data consistency
- **User Feedback**: Loading states and error messages for user awareness
- **Fallback Values**: Default values for missing or corrupted data
- **Category Validation**: Ensures valid category selection

## Integration Points

- **Dashboard**: Provides monthly expense totals for KPI display
- **Reports**: Supplies detailed expense data for CSV/PDF export
- **Taxes**: Expense data used for tax calculations and deductions
- **Currency Service**: All amounts formatted according to user's currency preference
- **Business Management**: Category management through business management screen

## Category Management

### Default Categories
The system supports common business expense categories:
- Rent/Lease
- Supplies
- Utilities
- Marketing
- Insurance
- Equipment
- Professional Services
- Travel
- Miscellaneous

### Custom Categories
Users can create unlimited custom categories with:
- Custom names
- Color coding
- Icon selection
- Sort order preferences

## Reporting and Analytics

### Monthly Summaries
- Total expenses by category
- Expense trends over time
- Category-wise spending analysis
- Vendor tracking and analysis

### Export Capabilities
- CSV export with detailed expense data
- PDF reports with categorized summaries
- Date range selection for custom reports
- Integration with accounting software

## Data Security and Privacy

- **Local Storage**: All expense data stored locally on device
- **User Isolation**: Complete data separation between users
- **Encryption**: Device-level encryption for sensitive financial data
- **Backup**: Local data backup and recovery capabilities
