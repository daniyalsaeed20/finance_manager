# Income Tracking Feature

## Overview
The Income Tracking feature is the core functionality that allows barbers and salon owners to log their daily income from services and tips. It provides a comprehensive system for managing service templates, recording daily transactions, and tracking income over time.

## Key Components

### 1. Service Templates (`ServiceTemplate`)
**Purpose**: Predefined services with standard pricing that can be quickly selected during income entry.

**Key Properties**:
- `id`: Auto-incrementing unique identifier
- `name`: Service name (e.g., "Haircut", "Beard Trim", "Shampoo")
- `defaultPriceMinor`: Price stored in minor currency units (cents) to avoid floating-point precision issues
- `active`: Boolean flag to enable/disable services
- `sortOrder`: Custom ordering for display
- `userId`: User isolation for multi-user support

**Important Implementation Details**:
- Prices are stored in minor units (e.g., $15.00 = 1500 minor units)
- Uses Isar database for local storage with automatic indexing
- Supports user-specific templates for data isolation

### 2. Income Records (`IncomeRecord`)
**Purpose**: Daily income entries that capture all services provided and tips received.

**Key Properties**:
- `id`: Auto-incrementing unique identifier
- `date`: Transaction date (stored as DateTime)
- `services`: List of `IncomeServiceCount` objects
- `tipMinor`: Optional tip amount in minor units
- `totalMinor`: Cached total for fast queries
- `note`: Optional notes for the transaction
- `userId`: User isolation

**Important Implementation Details**:
- `totalMinor` is automatically calculated as: `sum(services.price * count) + tip`
- Supports multiple services per day with individual counts
- Date-based grouping for monthly summaries
- Real-time total calculation for performance

### 3. Income Service Count (`IncomeServiceCount`)
**Purpose**: Embedded object that captures service details within an income record.

**Key Properties**:
- `serviceName`: Name of the service (captured at time of entry)
- `priceMinor`: Price at time of service (may differ from template)
- `count`: Number of times this service was provided

**Important Implementation Details**:
- Price is captured at time of entry to preserve historical accuracy
- Supports multiple instances of the same service per day
- Embedded object for efficient storage and queries

## Backend Architecture

### Repository Pattern (`IncomeRepository`)
**Purpose**: Handles all data operations for income-related entities.

**Key Methods**:
- `getServiceTemplates(userId)`: Retrieves user's service templates
- `upsertServiceTemplate(template)`: Creates or updates service templates
- `deleteServiceTemplate(id)`: Removes service templates
- `addIncomeRecord(record)`: Creates new income records with automatic total calculation
- `updateIncomeRecord(record)`: Updates existing records
- `getIncomeForDateRange(start, end, userId)`: Retrieves income records for specific periods

**Important Implementation Details**:
- Uses Isar database with optimized queries
- Implements stream-based real-time updates
- Automatic total calculation on record creation/update
- Date range queries with inclusive boundaries
- User isolation for multi-user support

### State Management (`IncomeCubit`)
**Purpose**: Manages application state for income-related UI components.

**Key Methods**:
- `loadTemplates(userId)`: Loads service templates into state
- `addOrUpdateTemplate(template)`: Manages template CRUD operations
- `addIncome(record)`: Handles income record creation
- `updateIncome(record)`: Handles income record updates
- `refreshRange(start, end, userId)`: Refreshes data for specific date ranges

**Important Implementation Details**:
- Uses BLoC pattern for predictable state management
- Automatic state updates after data operations
- Loading states for UI feedback
- Error handling and recovery

## User Interface

### Income Screen (`IncomeScreen`)
**Purpose**: Main interface for income entry and management.

**Key Features**:
- Service template selection with quantity input
- Date picker for transaction date
- Tip input field
- Notes field for additional information
- Real-time total calculation
- Form validation and submission

**Important Implementation Details**:
- Reactive UI updates using BLoC pattern
- Form validation prevents invalid submissions
- Automatic total calculation as user inputs data
- Date-based record merging (multiple entries per day)
- Keyboard-friendly input handling

### Edit Income Screen (`EditIncomeScreen`)
**Purpose**: Interface for modifying existing income records.

**Key Features**:
- Pre-populated form with existing data
- Service modification capabilities
- Date and amount editing
- Delete functionality
- Validation and error handling

## Data Flow

1. **Service Template Creation**: User creates service templates with names and prices
2. **Daily Income Entry**: User selects services, quantities, adds tips and notes
3. **Record Processing**: System calculates totals and stores in local database
4. **Real-time Updates**: UI updates immediately through BLoC state management
5. **Monthly Aggregation**: Dashboard and reports aggregate daily records

## Performance Optimizations

- **Cached Totals**: `totalMinor` field prevents real-time calculations
- **Indexed Queries**: Isar database indexes on `userId` and `date` for fast lookups
- **Stream-based Updates**: Real-time UI updates without full data refreshes
- **Minor Unit Storage**: Avoids floating-point precision issues
- **Date Range Optimization**: Efficient queries for monthly summaries

## Error Handling

- **Validation**: Form validation prevents invalid data entry
- **Database Transactions**: Atomic operations ensure data consistency
- **User Feedback**: Loading states and error messages for user awareness
- **Fallback Values**: Default values for missing or corrupted data

## Integration Points

- **Dashboard**: Provides monthly income totals for KPI display
- **Reports**: Supplies detailed income data for CSV/PDF export
- **Goals**: Income data used for goal progress tracking
- **Taxes**: Income data used for tax calculations
- **Currency Service**: All amounts formatted according to user's currency preference
