# Currency Management Feature

## Overview
The Currency Management feature provides comprehensive currency support for the Quaestor personal finance app. It enables users to select their preferred currency, formats all monetary values consistently throughout the app, and provides real-time currency updates across all screens.

## Key Components

### 1. Currency Service (`CurrencyService`)
**Purpose**: Centralized service for currency management and formatting.

**Key Properties**:
- `_currencyKey`: SharedPreferences key for storing user's currency preference
- `_currencyController`: StreamController for real-time currency updates
- `_cachedCurrency`: Cached currency for synchronous access
- `_currencies`: Comprehensive list of supported currencies

**Important Implementation Details**:
- Singleton pattern for centralized currency management
- Stream-based real-time updates for reactive UI
- Cached currency for performance optimization
- Comprehensive currency database with 50+ currencies

### 2. Currency Model (`Currency`)
**Purpose**: Data model representing a currency with its properties.

**Key Properties**:
- `code`: ISO currency code (e.g., "USD", "EUR", "GBP")
- `symbol`: Currency symbol (e.g., "$", "€", "£")
- `name`: Full currency name (e.g., "US Dollar", "Euro")

**Important Implementation Details**:
- Immutable currency model for data consistency
- Equality comparison based on currency code
- String representation for debugging and display
- Hash code implementation for efficient storage

## Backend Architecture

### Currency Database
**Purpose**: Comprehensive database of supported currencies.

**Supported Currencies** (50+ currencies):
- **Major Currencies**: USD, EUR, GBP, JPY, CAD, AUD, CHF, CNY
- **Regional Currencies**: INR, BRL, RUB, KRW, MXN, SGD, HKD, NZD
- **European Currencies**: SEK, NOK, DKK, PLN, CZK, HUF, RON, BGN
- **Asian Currencies**: THB, MYR, PHP, IDR, VND, TWD, HKD, SGD
- **Other Currencies**: ZAR, TRY, ILS, AED, SAR, QAR, KWD, BHD

**Important Implementation Details**:
- Static currency list for performance
- Comprehensive coverage of global currencies
- Consistent naming and symbol conventions
- Easy extensibility for additional currencies

### Stream-Based Updates
**Purpose**: Real-time currency updates across the application.

**Stream Architecture**:
- `StreamController<Currency>`: Broadcast stream for currency changes
- `currencyStream`: Public stream for UI components
- Automatic emission of currency changes
- Multiple listeners support

**Important Implementation Details**:
- Broadcast stream for multiple listeners
- Automatic stream emission on currency changes
- Proper stream disposal for memory management
- Error handling for stream operations

### Caching System
**Purpose**: Performance optimization through currency caching.

**Caching Strategy**:
- `_cachedCurrency`: Synchronous access to current currency
- Cache updates on currency changes
- Fallback to USD if cache is empty
- Performance optimization for frequent access

**Important Implementation Details**:
- Synchronous access for UI performance
- Automatic cache invalidation on changes
- Fallback mechanisms for reliability
- Memory-efficient caching strategy

## User Interface

### Settings Screen Integration
**Purpose**: Currency selection interface in app settings.

**Key Features**:
- Current currency display with name and symbol
- Currency selector dialog with search functionality
- Real-time currency updates using StreamBuilder
- Visual currency indicators

**Important Implementation Details**:
- StreamBuilder for reactive currency display
- Search functionality for currency selection
- Dialog-based currency picker
- Immediate UI updates on currency changes

### Currency Selector Dialog (`_CurrencySelectorDialog`)
**Purpose**: Interactive currency selection interface.

**Key Features**:
- Searchable currency list
- Currency filtering by name, code, or symbol
- Visual currency display with symbols
- Confirmation and cancellation options

**Important Implementation Details**:
- Real-time search filtering
- Case-insensitive search functionality
- Visual currency representation
- Proper dialog state management

## Currency Formatting

### Amount Formatting
**Purpose**: Consistent currency formatting throughout the application.

**Formatting Methods**:
- `formatAmount(minorAmount)`: Async formatting with current currency
- `formatAmountWithCurrency(minorAmount, currency)`: Format with specific currency
- `formatAmountSync(minorAmount)`: Synchronous formatting with cached currency

**Important Implementation Details**:
- Minor unit conversion (cents to dollars)
- NumberFormat.currency for consistent formatting
- English locale for consistent decimal formatting
- Error handling for formatting failures

### Minor Unit System
**Purpose**: Precise currency handling without floating-point errors.

**Minor Unit Conversion**:
```
Minor Amount = Major Amount × 100
Major Amount = Minor Amount ÷ 100
```

**Examples**:
- $15.00 = 1500 minor units
- €25.50 = 2550 minor units
- £10.25 = 1025 minor units

**Important Implementation Details**:
- All amounts stored in minor units
- Conversion only for display purposes
- Consistent precision across all calculations
- No floating-point arithmetic errors

## Data Flow

### Currency Selection Flow
1. **User Selection**: User selects currency in settings
2. **Storage**: Currency code saved to SharedPreferences
3. **Cache Update**: Cached currency updated
4. **Stream Emission**: New currency emitted to stream
5. **UI Updates**: All listening components update automatically

### Currency Initialization Flow
1. **App Startup**: CurrencyService.initialize() called
2. **Load Currency**: User's currency loaded from SharedPreferences
3. **Cache Currency**: Currency cached for synchronous access
4. **Emit Initial**: Initial currency emitted to stream
5. **UI Ready**: All components receive initial currency

## Performance Optimizations

### Synchronous Access
**Purpose**: Optimizes UI performance with cached currency access.

**Optimization Strategies**:
- Cached currency for immediate access
- Synchronous formatting methods
- Fallback mechanisms for reliability
- Minimal async operations for UI

### Stream Efficiency
**Purpose**: Efficient real-time updates without performance impact.

**Optimization Details**:
- Broadcast stream for multiple listeners
- Automatic stream emission only on changes
- Proper stream disposal for memory management
- Error handling for stream operations

### Memory Management
**Purpose**: Efficient memory usage for currency management.

**Memory Optimization**:
- Static currency list (no dynamic allocation)
- Cached currency (single instance)
- Proper stream disposal
- Minimal object creation

## Error Handling

### Currency Validation
**Purpose**: Ensures valid currency selection and formatting.

**Validation Scenarios**:
- Invalid currency code handling
- Missing currency fallback
- Formatting error recovery
- Stream error handling

**Important Implementation Details**:
- Fallback to USD for invalid currencies
- Error recovery mechanisms
- User feedback for currency issues
- Graceful degradation on errors

### Fallback Mechanisms
**Purpose**: Ensures app functionality even with currency errors.

**Fallback Strategies**:
- Default to USD if no currency set
- Use cached currency if stream fails
- Fallback formatting for display errors
- Error messages for user awareness

## Integration Points

### Dashboard Integration
**Purpose**: Real-time currency updates in dashboard displays.

**Integration Details**:
- StreamBuilder for reactive currency updates
- KPI cards update with currency changes
- Goal progress displays with correct currency
- Fallback to cached currency for performance

### Income/Expense Integration
**Purpose**: Currency formatting in income and expense displays.

**Integration Details**:
- All amounts formatted with user's currency
- Real-time currency updates in lists
- Form inputs with currency formatting
- Export data with correct currency

### Reports Integration
**Purpose**: Currency consistency in exported reports.

**Integration Details**:
- CSV exports with user's currency
- PDF reports with correct currency symbols
- Consistent formatting across all exports
- Currency information in report headers

## Data Persistence

### SharedPreferences Storage
**Purpose**: Persistent storage of user's currency preference.

**Storage Details**:
- Currency code stored as string
- Automatic loading on app startup
- Immediate persistence on changes
- Cross-session currency retention

**Important Implementation Details**:
- Simple string storage for currency code
- Automatic loading in initialize() method
- Immediate save on currency changes
- Error handling for storage failures

### Initialization Process
**Purpose**: Proper currency initialization on app startup.

**Initialization Steps**:
1. Load currency from SharedPreferences
2. Cache currency for synchronous access
3. Emit initial currency to stream
4. UI components receive initial currency

**Important Implementation Details**:
- Called in main() before app starts
- Ensures currency is available immediately
- Stream emission for reactive UI
- Error handling for initialization failures

## Security and Privacy

### Local Storage Only
**Purpose**: Ensures currency preferences remain private.

**Privacy Measures**:
- Currency preference stored locally only
- No external transmission of currency data
- User has complete control over currency selection
- No tracking of currency usage patterns

### Data Isolation
**Purpose**: Ensures currency preferences are user-specific.

**Isolation Details**:
- Currency preference per device/user
- No sharing of currency preferences
- Local storage with device encryption
- User-controlled currency management
