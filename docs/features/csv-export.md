# CSV Export Feature

## Overview
The CSV Export feature enables users to export their financial data in CSV format for external use, accounting software integration, or backup purposes. It provides comprehensive data export with customizable date ranges and detailed transaction information.

## Key Components

### 1. Export Service (`ExportService`)
**Purpose**: Core service handling CSV file generation and management.

**Key Methods**:
- `exportCsv(filename, rows)`: Generates CSV files from data rows
- `exportPdf(filename, title, table, additionalData)`: Generates PDF reports
- File management and temporary directory handling

**Important Implementation Details**:
- Singleton pattern for centralized export operations
- Temporary directory management for file storage
- CSV generation using the `csv` package
- PDF generation using the `pdf` package
- File naming conventions with timestamps

### 2. Exported Files Screen (`ExportedFilesScreen`)
**Purpose**: Interface for managing and accessing exported files.

**Key Features**:
- List of all exported files (CSV and PDF)
- File sharing capabilities
- File preview functionality
- File management (view, share, delete)
- File type identification and icons

**Important Implementation Details**:
- Automatic file discovery in exports directory
- File sorting by modification time (newest first)
- File type filtering (CSV and PDF only)
- Share functionality using device sharing options
- File preview for CSV files with data table display

## Backend Architecture

### CSV Generation Process
**Purpose**: Converts financial data into CSV format for external use.

**Data Sources**:
- **Income Records**: Daily income transactions with service details
- **Expense Records**: Expense transactions with category information
- **Date Range Filtering**: Customizable date range selection
- **User Data Isolation**: User-specific data export only

**CSV Structure**:
```csv
Date,Type,Category/Services,Amount,Notes
2025-01-15,Income,Haircut,$25.00,Regular client
2025-01-15,Income,Tip,$5.00,Great service
2025-01-16,Expense,Supplies,$45.00,Shampoo and conditioner
```

**Important Implementation Details**:
- Standardized CSV format for compatibility
- Currency formatting with user's selected currency
- Date formatting for consistent display
- Service and category name preservation
- Notes field inclusion for context

### File Management System
**Purpose**: Handles file storage, organization, and access.

**File Operations**:
- **Creation**: New CSV files generated in temporary directory
- **Storage**: Files stored in device's temporary directory
- **Organization**: Files organized in `/exports` subdirectory
- **Cleanup**: Automatic cleanup of old files (optional)

**Important Implementation Details**:
- Temporary directory usage for file storage
- Automatic directory creation if not exists
- File naming with date range and timestamp
- File type validation and filtering
- Cross-platform file path handling

## User Interface

### Reports Screen (`ReportsScreen`)
**Purpose**: Main interface for data export and report generation.

**Key Features**:
- Date range selector for export period
- Export format selection (CSV, PDF)
- Export button with loading states
- Export history and file management
- Data preview before export

**Important Implementation Details**:
- Date range picker for custom export periods
- Format selection with clear options
- Loading indicators during export process
- Success/error feedback for user awareness
- Navigation to exported files screen

### Export Process Flow
1. **Date Range Selection**: User selects start and end dates
2. **Data Collection**: System gathers income and expense data
3. **CSV Generation**: Data formatted into CSV structure
4. **File Creation**: CSV file created in temporary directory
5. **User Notification**: Success message with file location
6. **Navigation**: Automatic navigation to exported files screen

## Data Export Details

### Income Data Export
**Purpose**: Comprehensive income transaction export.

**Included Data**:
- **Transaction Date**: Date of income entry
- **Transaction Type**: "Income" identifier
- **Service Details**: Service name and pricing
- **Amount**: Service amount in user's currency
- **Notes**: Additional transaction notes
- **Tips**: Separate entries for tip transactions

**Important Implementation Details**:
- Individual service entries for detailed tracking
- Tip entries as separate transactions
- Price preservation at time of transaction
- Service count multiplication for accurate totals
- Date formatting for external software compatibility

### Expense Data Export
**Purpose**: Comprehensive expense transaction export.

**Included Data**:
- **Transaction Date**: Date of expense entry
- **Transaction Type**: "Expense" identifier
- **Category**: Expense category name
- **Amount**: Expense amount in user's currency
- **Notes**: Additional expense notes
- **Vendor**: Vendor/supplier information (if provided)

**Important Implementation Details**:
- Category name resolution from category IDs
- Vendor information inclusion when available
- Amount formatting with user's currency
- Date formatting for external software compatibility
- Complete expense transaction details

### Export File Naming
**Purpose**: Consistent and descriptive file naming convention.

**Naming Convention**:
```
CSV-YYYY-MM-DD_to_YYYY-MM-DD.csv
PDF-YYYY-MM-DD_to_YYYY-MM-DD.pdf
```

**Examples**:
- `CSV-2025-01-01_to_2025-01-31.csv`
- `PDF-2025-01-15_to_2025-01-15.pdf`

**Important Implementation Details**:
- Date range inclusion in filename
- Format identification in filename
- Chronological sorting by filename
- Cross-platform filename compatibility
- Unique naming to prevent conflicts

## Integration Points

### Currency Service Integration
**Purpose**: Ensures exported data uses user's selected currency.

**Integration Details**:
- All amounts formatted with user's currency symbol
- Currency formatting consistent with app display
- Real-time currency updates in exports
- Currency preference preservation in exported data

### User Data Isolation
**Purpose**: Ensures exports contain only user's data.

**Security Details**:
- User ID filtering for all data queries
- No cross-user data contamination
- Secure data access patterns
- User authentication verification

### Repository Integration
**Purpose**: Data retrieval from multiple repositories.

**Data Sources**:
- `IncomeRepository.getIncomeForDateRange()`
- `ExpenseRepository.getExpensesForDateRange()`
- `ExpenseRepository.getCategories()`
- Date range filtering for all queries

## File Sharing and Access

### Share Functionality
**Purpose**: Enables users to share exported files with external parties.

**Sharing Options**:
- **Email**: Direct email attachment
- **Cloud Storage**: Upload to cloud services
- **Messaging**: Share via messaging apps
- **Print**: Direct printing from device
- **Other Apps**: Share with compatible applications

**Important Implementation Details**:
- Uses `share_plus` package for cross-platform sharing
- File type detection for appropriate sharing options
- Temporary file access for sharing
- Automatic cleanup after sharing

### File Preview
**Purpose**: Allows users to preview CSV files before sharing.

**Preview Features**:
- **Data Table Display**: Formatted table view of CSV data
- **Scrollable Content**: Horizontal and vertical scrolling
- **Column Headers**: Clear column identification
- **Data Validation**: Verification of exported data accuracy

**Important Implementation Details**:
- CSV parsing using `csv` package
- Data table widget for formatted display
- Responsive table layout for mobile viewing
- Error handling for corrupted files

## Performance Optimizations

### Efficient Data Processing
**Purpose**: Optimizes export performance for large datasets.

**Optimization Strategies**:
- **Batch Processing**: Efficient data retrieval in batches
- **Memory Management**: Minimal memory usage during export
- **Stream Processing**: Large file handling without memory issues
- **Background Processing**: Non-blocking export operations

### File Management
**Purpose**: Efficient file storage and retrieval.

**Optimization Details**:
- **Temporary Storage**: Efficient use of device storage
- **File Indexing**: Quick file discovery and sorting
- **Cleanup Strategies**: Automatic old file removal
- **Cross-platform Compatibility**: Consistent behavior across platforms

## Error Handling

### Export Error Handling
**Purpose**: Graceful handling of export failures.

**Error Scenarios**:
- **Data Access Errors**: Repository query failures
- **File Creation Errors**: Storage permission issues
- **Format Errors**: CSV generation failures
- **User Feedback**: Clear error messages and recovery options

### File Access Errors
**Purpose**: Handling file system access issues.

**Error Handling**:
- **Permission Errors**: Storage access permission issues
- **File Not Found**: Missing or deleted files
- **Corruption**: File integrity validation
- **Recovery Options**: Retry mechanisms and alternatives

## Data Security and Privacy

### Local File Storage
**Purpose**: Ensures exported data remains secure and private.

**Security Measures**:
- **Local Storage Only**: Files stored only on user's device
- **No Cloud Upload**: No automatic cloud synchronization
- **User Control**: User decides when and how to share files
- **Temporary Storage**: Files in temporary directory for easy cleanup

### Data Privacy
**Purpose**: Protects user's financial data privacy.

**Privacy Measures**:
- **User-Controlled Sharing**: Only user can initiate file sharing
- **No External Transmission**: No automatic data transmission
- **Local Processing**: All export processing done locally
- **Data Isolation**: Complete user data separation
