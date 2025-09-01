# Goal Tracking Feature

## Overview
The Goal Tracking feature allows barbers and salon owners to set monthly income goals and track their progress toward achieving them. It provides motivation through visual progress indicators and helps users stay focused on their financial targets.

## Key Components

### 1. Monthly Goals (`MonthlyGoal`)
**Purpose**: Represents a monthly income target with associated strategies.

**Key Properties**:
- `id`: Auto-incrementing unique identifier
- `monthKey`: Month identifier in format "YYYY-MM" (e.g., "2025-01")
- `targetAmountMinor`: Target income amount in minor currency units (cents)
- `strategies`: List of `GoalStrategyItem` objects for achieving the goal
- `userId`: User isolation for multi-user support

**Important Implementation Details**:
- Month-based goal setting with unique month keys
- Target amounts stored in minor units for precision
- Strategy items for goal achievement planning
- User-specific goals for data isolation

### 2. Goal Strategy Items (`GoalStrategyItem`)
**Purpose**: Individual strategies or action items for achieving monthly goals.

**Key Properties**:
- `title`: Strategy description (e.g., "Increase client base", "Raise service prices")

**Important Implementation Details**:
- Embedded objects within monthly goals
- Simple text-based strategy descriptions
- Supports multiple strategies per goal

## Backend Architecture

### Repository Pattern (`GoalRepository`)
**Purpose**: Handles all data operations for goal-related entities.

**Key Methods**:
- `upsertGoal(goal)`: Creates or updates monthly goals
- `getGoalForMonth(monthKey, userId)`: Retrieves goal for specific month
- `getAllGoalsForUser(userId)`: Retrieves all goals for historical view
- `getMostRecentGoal(userId)`: Gets the most recent goal for fallback
- `getGoalForMonthWithFallback(monthKey, userId)`: Smart goal retrieval with fallback logic
- `deleteGoal(id)`: Removes goal records

**Important Implementation Details**:
- Smart fallback logic: if no goal exists for current month, uses most recent goal
- Month-based goal management with automatic fallback
- Stream-based real-time updates for UI reactivity
- User isolation for multi-user support
- Historical goal tracking for progress analysis

### State Management (`GoalCubit`)
**Purpose**: Manages application state for goal-related UI components.

**Key Methods**:
- `loadForMonth(monthKey, userId)`: Loads goal for specific month
- `loadAllGoals(userId)`: Loads all goals for historical view
- `upsert(goal)`: Manages goal CRUD operations
- `delete(id)`: Handles goal deletion

**Important Implementation Details**:
- Uses BLoC pattern for predictable state management
- Month-specific goal loading with fallback support
- Loading states for UI feedback
- Automatic state updates after data operations

## User Interface

### Goals Screen (`GoalsScreen`)
**Purpose**: Main interface for goal management and progress tracking.

**Key Features**:
- Monthly goal setting with target amount input
- Strategy planning with multiple strategy items
- Visual progress indicators
- Goal history navigation
- Progress charts and analytics
- Goal achievement tracking

**Important Implementation Details**:
- Month selector for goal management
- Real-time progress calculation
- Visual progress bars and charts
- Strategy management interface
- Historical goal comparison

### Monthly Goal History Screen (`MonthlyGoalHistoryScreen`)
**Purpose**: Historical view of past goals and achievements.

**Key Features**:
- Chronological list of past goals
- Achievement status indicators
- Performance analytics
- Goal comparison tools
- Historical progress tracking

## Goal Logic and Calculations

### Progress Calculation
```
Progress = (Current Month Income / Target Amount) * 100
```

### Fallback Logic
1. **Primary**: Look for goal set for current month
2. **Fallback**: If no current month goal, use most recent goal
3. **Default**: If no goals exist, show "No Goal Set" message

### Achievement Status
- **Achieved**: Current income >= Target amount
- **In Progress**: Current income < Target amount
- **Not Started**: No income recorded for the month

## Data Flow

1. **Goal Creation**: User sets monthly target amount and strategies
2. **Progress Tracking**: System calculates progress based on actual income
3. **Real-time Updates**: UI updates progress as income is recorded
4. **Historical Analysis**: Past goals stored for performance tracking
5. **Fallback Management**: Smart goal selection for current month

## Performance Optimizations

- **Cached Progress**: Real-time progress calculation without database queries
- **Stream-based Updates**: Real-time UI updates through BLoC pattern
- **Efficient Queries**: Optimized database queries for goal retrieval
- **Fallback Caching**: Smart fallback logic reduces database calls
- **Historical Data**: Efficient storage and retrieval of past goals

## Error Handling

- **Validation**: Goal amount validation prevents invalid targets
- **Fallback Logic**: Graceful handling of missing goals
- **User Feedback**: Clear messaging for goal status
- **Data Consistency**: Atomic operations ensure goal integrity

## Integration Points

- **Dashboard**: Displays current goal progress prominently
- **Income Tracking**: Uses income data for progress calculation
- **Reports**: Includes goal data in monthly reports
- **Currency Service**: Goal amounts formatted according to user's currency
- **Business Management**: Goal management through business management screen

## Visual Indicators

### Progress Bar
- Linear progress indicator showing completion percentage
- Color-coded progress (red: behind, yellow: on track, green: achieved)
- Percentage display with precise calculations

### Goal Status Cards
- Current goal display with target amount
- Progress percentage with visual indicators
- Achievement status with appropriate messaging

### Charts and Analytics
- Monthly progress charts
- Historical goal comparison
- Achievement rate analytics
- Performance trends over time

## Motivation Features

### Achievement Messaging
- Positive reinforcement for goal achievement
- Encouragement for goals in progress
- Suggestions for goal setting when none exist

### Progress Notifications
- Real-time progress updates
- Milestone celebrations
- Achievement notifications

### Goal Recommendations
- Smart goal suggestions based on historical performance
- Industry benchmark recommendations
- Seasonal goal adjustments

## Data Security and Privacy

- **Local Storage**: All goal data stored locally on device
- **User Isolation**: Complete data separation between users
- **Historical Preservation**: Goals maintained for long-term analysis
- **Privacy**: No external sharing of personal financial goals
