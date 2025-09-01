# Tax Management Feature

## Overview
The Tax Management feature provides users with tools to estimate and track their tax obligations. It calculates estimated taxes based on net profit and allows users to record tax payments for comprehensive tax planning.

## Key Components

### 1. Tax Plans (`TaxPlan`)
**Purpose**: Represents tax planning periods with estimated tax rates and due dates.

**Key Properties**:
- `id`: Auto-incrementing unique identifier
- `periodKey`: Period identifier (e.g., "2025-01" for month or "2025-Q1" for quarter)
- `estimatedRate`: Tax rate as decimal (0.0 to 1.0, e.g., 0.15 for 15%)
- `dueDate`: Optional due date for tax payment
- `userId`: User isolation for multi-user support

**Important Implementation Details**:
- Flexible period tracking (monthly or quarterly)
- Decimal-based tax rate storage for precision
- Optional due date tracking for payment planning
- User-specific tax plans for data isolation

### 2. Tax Payments (`TaxPayment`)
**Purpose**: Records actual tax payments made by the user.

**Key Properties**:
- `id`: Auto-incrementing unique identifier
- `date`: Payment date (stored as DateTime)
- `amountMinor`: Payment amount in minor currency units (cents)
- `method`: Optional payment method (e.g., "Bank Transfer", "Check")
- `note`: Optional additional notes
- `userId`: User isolation

**Important Implementation Details**:
- Amount stored in minor units to avoid floating-point precision issues
- Payment method tracking for record keeping
- Date-based organization for tax period tracking
- Optional notes for additional context

## Backend Architecture

### Repository Pattern (`TaxRepository`)
**Purpose**: Handles all data operations for tax-related entities.

**Key Methods**:
- `upsertPlan(plan)`: Creates or updates tax plans
- `getPlans(userId)`: Retrieves user's tax plans
- `deletePlan(id)`: Removes tax plans
- `addPayment(payment)`: Creates new tax payment records
- `getPayments(userId)`: Retrieves user's tax payments
- `deletePayment(id)`: Removes tax payment records

**Important Implementation Details**:
- Uses Isar database with optimized queries
- User isolation for multi-user support
- Atomic operations for data consistency
- Efficient storage and retrieval of tax data

### State Management (`TaxCubit`)
**Purpose**: Manages application state for tax-related UI components.

**Key Methods**:
- `load(userId)`: Loads tax plans and payments into state
- `upsertPlan(plan)`: Manages tax plan CRUD operations
- `deletePlan(id)`: Handles tax plan deletion
- `addPayment(payment)`: Handles tax payment creation
- `deletePayment(id)`: Handles tax payment deletion

**Important Implementation Details**:
- Uses BLoC pattern for predictable state management
- Combined loading of plans and payments
- Loading states for UI feedback
- Automatic state updates after data operations

## User Interface

### Taxes Screen (`TaxesScreen`)
**Purpose**: Main interface for tax management and estimation.

**Key Features**:
- Tax rate configuration (default 15%)
- Monthly tax summary with calculations
- Tax payment recording
- Payment history display
- Tax planning tools
- Due date tracking

**Important Implementation Details**:
- Real-time tax calculation based on net profit
- Interactive tax rate adjustment
- Payment form with validation
- Historical payment tracking
- Visual tax summary cards

## Tax Calculations

### Monthly Tax Estimation
```
Estimated Tax = Net Profit × Tax Rate
Net Profit = Total Income - Total Expenses
```

### Tax Rate Configuration
- **Default Rate**: 15% (configurable by user)
- **Rate Range**: 0% to 100% (0.0 to 1.0 in decimal)
- **User Customization**: Users can set their own tax rate
- **Real-time Updates**: Tax calculations update immediately when rate changes

### Tax Summary Components
1. **Monthly Income**: Total income for the month
2. **Monthly Expenses**: Total expenses for the month
3. **Net Profit**: Income minus expenses
4. **Estimated Tax**: Net profit multiplied by tax rate
5. **After-Tax Profit**: Net profit minus estimated tax

## Data Flow

1. **Tax Rate Setup**: User configures their tax rate (default 15%)
2. **Income/Expense Integration**: System pulls monthly income and expense data
3. **Tax Calculation**: Automatic calculation of estimated tax based on net profit
4. **Payment Recording**: User records actual tax payments made
5. **Historical Tracking**: Payment history maintained for tax planning

## Performance Optimizations

- **Real-time Calculations**: Immediate tax calculations without database queries
- **Cached Data**: Efficient retrieval of income and expense data
- **Stream-based Updates**: Real-time UI updates through BLoC pattern
- **Minor Unit Storage**: Avoids floating-point precision issues
- **Optimized Queries**: Efficient database operations for tax data

## Error Handling

- **Validation**: Tax rate validation prevents invalid percentages
- **Payment Validation**: Payment amount and date validation
- **User Feedback**: Clear error messages and loading states
- **Data Consistency**: Atomic operations ensure tax data integrity
- **Fallback Values**: Default tax rate when none is set

## Integration Points

- **Dashboard**: Provides monthly tax estimates for financial overview
- **Income Tracking**: Uses income data for tax calculations
- **Expense Tracking**: Uses expense data for net profit calculation
- **Reports**: Includes tax data in monthly reports and exports
- **Currency Service**: All amounts formatted according to user's currency

## Tax Planning Features

### Monthly Tax Summary
- **Income Display**: Total monthly income with currency formatting
- **Expense Display**: Total monthly expenses with currency formatting
- **Net Profit Calculation**: Automatic calculation of profit/loss
- **Tax Estimation**: Real-time tax calculation with user's rate
- **After-Tax Profit**: Final profit after estimated taxes

### Payment Tracking
- **Payment Recording**: Easy entry of tax payments made
- **Payment History**: Chronological list of all tax payments
- **Payment Methods**: Tracking of how taxes were paid
- **Notes**: Additional context for tax payments

### Tax Rate Management
- **Custom Rates**: Users can set their own tax rate
- **Rate Validation**: Ensures tax rates are within valid range
- **Real-time Updates**: Tax calculations update immediately
- **Rate History**: Optional tracking of rate changes over time

## Visual Indicators

### Tax Summary Cards
- **Income Card**: Monthly income total with currency formatting
- **Expense Card**: Monthly expense total with currency formatting
- **Net Profit Card**: Calculated profit/loss with color coding
- **Tax Card**: Estimated tax amount with rate display
- **After-Tax Card**: Final profit after taxes

### Payment History
- **Chronological List**: Payments sorted by date (newest first)
- **Payment Details**: Amount, date, method, and notes
- **Visual Indicators**: Color-coded payment status
- **Total Tracking**: Running total of payments made

## Compliance and Accuracy

### Disclaimer
- **Estimation Only**: Tax calculations are estimates, not professional tax advice
- **User Responsibility**: Users responsible for accurate tax reporting
- **Professional Consultation**: Recommends consulting tax professionals
- **Rate Accuracy**: Users must ensure tax rates are correct for their situation

### Data Accuracy
- **Precise Calculations**: Uses minor units for accurate calculations
- **Real-time Updates**: Calculations update with every data change
- **Validation**: Input validation prevents calculation errors
- **Audit Trail**: Payment history provides audit trail for tax records

## Data Security and Privacy

- **Local Storage**: All tax data stored locally on device
- **User Isolation**: Complete data separation between users
- **Sensitive Data**: Tax information kept private and secure
- **No External Sharing**: Tax data not shared with external services
- **Backup**: Local data backup for tax record preservation
