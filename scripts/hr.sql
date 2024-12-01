
--EMPLOYEE MASTER DATA
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15),
    HireDate DATE NOT NULL,
    BirthDate DATE,
    PositionID INT NOT NULL,
    DepartmentID INT,
    Status ENUM('Active', 'Inactive') DEFAULT 'Active',
    AddressID INT,
    EmergencyContactID INT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (AddressID) REFERENCES Addresses(AddressID),
    FOREIGN KEY (PositionID) REFERENCES Positions(PositionID),
    FOREIGN KEY (EmergencyContactID) REFERENCES EmergencyContacts(EmergencyContactID)
);

CREATE TABLE Addresses (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    StreetAddress VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    PostalCode VARCHAR(20),
    Country VARCHAR(50) DEFAULT 'USA'
);

CREATE TABLE EmergencyContacts (
    EmergencyContactID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    ContactName VARCHAR(100) NOT NULL,
    Relationship VARCHAR(50),
    PhoneNumber VARCHAR(15),
    Email VARCHAR(100)
);

CREATE TABLE Positions (
    PositionID INT PRIMARY KEY AUTO_INCREMENT,
    PositionName VARCHAR(100) NOT NULL UNIQUE,
    DepartmentID INT NOT NULL, 
    JobDescription TEXT, 
    IsActive BOOLEAN DEFAULT TRUE,
);

CREATE TABLE Level (
    LevelID INT PRIMARY KEY AUTO_INCREMENT,
    Levelname VARCHAR(100) NOT NULL UNIQUE, -- Example "Senior Associate" or "Staff Lead"
    PositionID INT NOT NULL, -- Levels are attached to positions
    LevelDescription TEXT, -- Detailed description of the position
    MinSalary DECIMAL(10, 2), -- Minimum salary for this position
    MaxSalary DECIMAL(10, 2), -- Maximum salary for this position
    IsActive BOOLEAN DEFAULT TRUE, -- Flag for whether the position is active
);

CREATE TABLE JobHistory (
    HistoryID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    PositionID INT NOT NULL, -- Job title during this period
    DepartmentID INT, -- Department for this job
    StartDate DATE NOT NULL, -- Start date of this job/position
    EndDate DATE, -- Nullable: End date of this job
    IsCurrentJob BOOLEAN DEFAULT FALSE, -- Flag for the current job
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (PositionID) REFERENCES Positions(PositionID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    SalaryAmount DECIMAL(10, 2) NOT NULL, -- Salary amount
    PayFrequency ENUM('Hourly', 'Monthly', 'Yearly') DEFAULT 'Monthly', -- Salary frequency
    EffectiveDate DATE NOT NULL, -- Date the salary takes effect
    EndDate DATE, -- Nullable: End date of this salary
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE WAGE (
    WageID INT PRIMARY KEY AUTO_INCREMENT
    EmployeeID  INT NOT NULL,
    WageAmount DECIMAL(10,2) NOT NULL,
    PayFrequency ENUM('Hourly', 'Monthly', 'Yearly') DEFAULT 'Monthly',
    EffectiveDate DATE NOT NULL,
    EndDate DATE,

)


CREATE TABLE BenefitsEnrollment (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    BenefitType VARCHAR(100) NOT NULL, -- Example: 'Health Insurance', '401(k)'
    ProviderName VARCHAR(100), -- Example: 'Blue Cross Blue Shield'
    PlanName VARCHAR(100), -- Example: 'Silver Plan'
    EnrollmentDate DATE NOT NULL, -- Date of benefit enrollment
    TerminationDate DATE, -- Nullable: Date of benefit termination
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


CREATE TABLE EmployeeTraining (
    TrainingID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    TrainingName VARCHAR(100) NOT NULL, -- Name of the training
    Provider VARCHAR(100), -- Training provider or organizer
    CompletionDate DATE, -- Date of completion
    CertificationReceived BOOLEAN DEFAULT FALSE, -- If a certification was received
    CertificationExpiryDate DATE, -- Nullable: Expiration date of certification
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);



--ORG STRUCTURE
CREATE TABLE Division (
    DivisionID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    DepartmentID INT(100),-- Example: 'Engineering', 'Human Resources'
    Description TEXT
);
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE, -- Example: 'Engineering', 'Human Resources'
    Description TEXT,                            -- Details about the department
    DivisionID INT,                      -- Reference to parent department for hierarchical org structure
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ParentDepartmentID) REFERENCES Departments(DepartmentID)
);
-- Table for organizational reporting relationships
CREATE TABLE OrganizationalStructure (
    StructureID INT PRIMARY KEY AUTO_INCREMENT,
    SupervisorID INT NOT NULL, -- Reference to the EmployeeID of the supervisor
    SubordinateID INT NOT NULL, -- Reference to the EmployeeID of the subordinate
    RelationshipType ENUM('Direct', 'Matrix', 'Mentor', 'Other') DEFAULT 'Direct', -- Type of reporting
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (SupervisorID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (SubordinateID) REFERENCES Employees(EmployeeID),
    UNIQUE (SupervisorID, SubordinateID) -- Prevent duplicate relationships
);

-- Table for defining teams
CREATE TABLE Teams (
    TeamID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL UNIQUE, -- Team name
    Description TEXT, -- Team description
    DepartmentID INT, -- Reference to the associated department
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Table for tracking team memberships
CREATE TABLE TeamMemberships (
    MembershipID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee in the team
    TeamID INT NOT NULL, -- Reference to the team
    RoleInTeam VARCHAR(100), -- Example: 'Lead', 'Member', 'Observer'
    StartDate DATE NOT NULL, -- Start date of membership
    EndDate DATE, -- Nullable: Membership end date
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID),
    UNIQUE (EmployeeID, TeamID) -- Prevent duplicate memberships
);





--NOT ENTERED INTO DATABASE




--BENEFITS AND EVERYTHING RELATED TO BENEFITS
CREATE TABLE BenefitsPlans (
    PlanID INT PRIMARY KEY AUTO_INCREMENT,
    PlanName VARCHAR(100) NOT NULL UNIQUE, -- Example: 'Health Insurance', 'Tuition Reimbursement'
    PlanType ENUM('Health', 'Retirement', 'Life Insurance', 'Wellness', 'Tuition Reimbursement', 'Other') NOT NULL,
    Provider VARCHAR(100), -- Name of the provider offering this plan
    Description TEXT, -- Detailed description of the benefit plan
    EmployeeCost DECIMAL(10, 2) DEFAULT 0.00, -- Monthly cost to the employee
    EmployerCost DECIMAL(10, 2) DEFAULT 0.00, -- Monthly cost to the employer
    MaximumBenefitAmount DECIMAL(10, 2), -- Maximum benefit amount (e.g., tuition reimbursement cap)
    CoverageStartDate DATE, -- When the plan becomes effective
    CoverageEndDate DATE, -- If applicable
    IsActive BOOLEAN DEFAULT TRUE, -- Whether this plan is currently active
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE EmployeeBenefits (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    PlanID INT NOT NULL, -- Reference to the benefit plan
    EnrollmentDate DATE NOT NULL, -- Date of enrollment
    CoverageStartDate DATE NOT NULL, -- Date coverage begins for the employee
    CoverageEndDate DATE, -- Date coverage ends, if applicable
    Status ENUM('Active', 'Terminated', 'Pending') DEFAULT 'Active', -- Status of the enrollment
    TerminationDate DATE, -- Date the benefit was terminated, if applicable
    Notes TEXT, -- Optional notes or comments about the enrollment
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (PlanID) REFERENCES BenefitsPlans(PlanID)
);

CREATE TABLE BenefitsEligibility (
    EligibilityID INT PRIMARY KEY AUTO_INCREMENT,
    PlanID INT NOT NULL, -- Reference to the benefit plan
    MinServiceYears DECIMAL(3, 1) DEFAULT 0.0, -- Minimum years of service required
    MinHoursWorkedPerWeek INT DEFAULT 0, -- Minimum weekly hours required for eligibility
    EmployeeType ENUM('Full-Time', 'Part-Time', 'Contractor', 'All') DEFAULT 'All', -- Type of employees eligible
    Notes TEXT, -- Additional eligibility notes
    FOREIGN KEY (PlanID) REFERENCES BenefitsPlans(PlanID)
);
CREATE TABLE BenefitsCosts (
    CostID INT PRIMARY KEY AUTO_INCREMENT,
    PlanID INT NOT NULL, -- Reference to the benefit plan
    EffectiveDate DATE NOT NULL, -- When this cost becomes effective
    EmployeeCost DECIMAL(10, 2) NOT NULL, -- Cost to employee
    EmployerCost DECIMAL(10, 2) NOT NULL, -- Cost to employer
    FOREIGN KEY (PlanID) REFERENCES BenefitsPlans(PlanID)
);
CREATE TABLE Dependents (
    DependentID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    DependentName VARCHAR(100) NOT NULL, -- Name of the dependent
    Relationship ENUM('Spouse', 'Child', 'Other') NOT NULL, -- Relationship to employee
    BirthDate DATE, -- Birthdate of the dependent
    IsCovered BOOLEAN DEFAULT FALSE, -- Whether the dependent is covered under benefits
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
CREATE TABLE BenefitsClaims (
    ClaimID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    PlanID INT NOT NULL, -- Reference to the benefit plan
    ClaimDate DATE NOT NULL, -- Date the claim was made
    ClaimAmount DECIMAL(10, 2) NOT NULL, -- Amount claimed
    Status ENUM('Submitted', 'Approved', 'Rejected', 'Paid') DEFAULT 'Submitted', -- Status of the claim
    Notes TEXT, -- Additional details about the claim
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (PlanID) REFERENCES BenefitsPlans(PlanID)
);
CREATE TABLE TuitionReimbursementClaims (
    ClaimID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    PlanID INT NOT NULL, -- Reference to the tuition reimbursement plan
    SubmissionDate DATE NOT NULL, -- Date of claim submission
    ClaimAmount DECIMAL(10, 2) NOT NULL, -- Amount claimed for reimbursement
    ApprovedAmount DECIMAL(10, 2), -- Approved reimbursement amount
    Status ENUM('Submitted', 'Approved', 'Rejected', 'Paid') DEFAULT 'Submitted', -- Claim status
    Notes TEXT, -- Additional details about the claim
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (PlanID) REFERENCES BenefitsPlans(PlanID)
);


CREATE TABLE PayrollIntegration (
    PayrollID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    PlanID INT NOT NULL, -- Reference to the benefit plan
    DeductionAmount DECIMAL(10, 2) NOT NULL, -- Amount deducted from the employee's paycheck
    EmployerContribution DECIMAL(10, 2) NOT NULL, -- Amount contributed by the employer
    PayDate DATE NOT NULL, -- Date of the payroll processing
    Notes TEXT, -- Optional notes about the deduction or contribution
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (PlanID) REFERENCES BenefitsPlans(PlanID)
);
CREATE TABLE DependentCoveragePeriods (
    CoveragePeriodID INT PRIMARY KEY AUTO_INCREMENT,
    DependentID INT NOT NULL, -- Reference to the dependent
    PlanID INT NOT NULL, -- Reference to the benefit plan
    CoverageStartDate DATE NOT NULL, -- When coverage starts for this dependent
    CoverageEndDate DATE, -- When coverage ends, if applicable
    Status ENUM('Active', 'Expired') DEFAULT 'Active', -- Status of the dependent’s coverage
    FOREIGN KEY (DependentID) REFERENCES Dependents(DependentID),
    FOREIGN KEY (PlanID) REFERENCES BenefitsPlans(PlanID)
);
CREATE TABLE WellnessPrograms (
    ProgramID INT PRIMARY KEY AUTO_INCREMENT,
    ProgramName VARCHAR(100) NOT NULL UNIQUE, -- Example: 'Gym Membership', 'Mental Health Counseling'
    Description TEXT, -- Description of the program
    Provider VARCHAR(100), -- Organization providing the wellness service
    EmployeeCost DECIMAL(10, 2) DEFAULT 0.00, -- Cost to the employee
    EmployerCost DECIMAL(10, 2) DEFAULT 0.00, -- Cost to the employer
    StartDate DATE NOT NULL, -- Program start date
    EndDate DATE, -- Program end date
    IsActive BOOLEAN DEFAULT TRUE, -- Whether this program is active
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);




--PAYROLL
CREATE TABLE PayrollPeriods (
    PayrollPeriodID INT PRIMARY KEY AUTO_INCREMENT,
    StartDate DATE NOT NULL, -- Start of the pay period
    EndDate DATE NOT NULL, -- End of the pay period
    PayDate DATE NOT NULL, -- When employees are paid for this period
    Status ENUM('Open', 'Processing', 'Closed') DEFAULT 'Open', -- Pay period status
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE EmployeePayroll (
    EmployeePayrollID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    PayrollPeriodID INT NOT NULL, -- Reference to the payroll period
    BaseSalary DECIMAL(10, 2) NOT NULL, -- Regular salary for the pay period
    OvertimeHours DECIMAL(5, 2) DEFAULT 0.00, -- Number of overtime hours worked
    OvertimeRate DECIMAL(10, 2) DEFAULT 0.00, -- Overtime pay rate
    Bonuses DECIMAL(10, 2) DEFAULT 0.00, -- Any bonuses paid
    BenefitsDeductions DECIMAL(10, 2) DEFAULT 0.00, -- Total deductions for benefits
    TaxesWithheld DECIMAL(10, 2) DEFAULT 0.00, -- Total tax withheld
    NetPay DECIMAL(10, 2) NOT NULL, -- Final amount paid to the employee
    PaymentStatus ENUM('Pending', 'Paid', 'Failed') DEFAULT 'Pending', -- Status of payment
    Notes TEXT, -- Optional comments
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (PayrollPeriodID) REFERENCES PayrollPeriods(PayrollPeriodID)
);
CREATE TABLE PayrollDeductions (
    DeductionID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeePayrollID INT NOT NULL, -- Reference to EmployeePayroll
    DeductionType ENUM('Benefits', 'Taxes', 'Garnishments', 'Other') NOT NULL, -- Type of deduction
    Description VARCHAR(255), -- Explanation of the deduction
    Amount DECIMAL(10, 2) NOT NULL, -- Amount deducted
    FOREIGN KEY (EmployeePayrollID) REFERENCES EmployeePayroll(EmployeePayrollID)
);
CREATE TABLE PayrollBonuses (
    BonusID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeePayrollID INT NOT NULL, -- Reference to EmployeePayroll
    BonusType ENUM('Performance', 'Holiday', 'Retention', 'Other') NOT NULL, -- Type of bonus
    Amount DECIMAL(10, 2) NOT NULL, -- Bonus amount
    Description VARCHAR(255), -- Reason for the bonus
    AwardDate DATE NOT NULL, -- Date the bonus is awarded
    FOREIGN KEY (EmployeePayrollID) REFERENCES EmployeePayroll(EmployeePayrollID)
);
CREATE TABLE PayrollTaxes (
    TaxID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeePayrollID INT NOT NULL, -- Reference to EmployeePayroll
    TaxType ENUM('Federal', 'State', 'Local', 'Medicare', 'Social Security', 'Other') NOT NULL,
    TaxRate DECIMAL(5, 2) NOT NULL, -- Tax rate as a percentage
    TaxAmount DECIMAL(10, 2) NOT NULL, -- Amount withheld for this tax
    FOREIGN KEY (EmployeePayrollID) REFERENCES EmployeePayroll(EmployeePayrollID)
);
CREATE TABLE PayrollAdjustments (
    AdjustmentID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeePayrollID INT NOT NULL, -- Reference to EmployeePayroll
    AdjustmentType ENUM('Credit', 'Debit') NOT NULL, -- Type of adjustment
    Reason TEXT NOT NULL, -- Explanation for the adjustment
    Amount DECIMAL(10, 2) NOT NULL, -- Adjustment amount
    AdjustmentDate DATE NOT NULL, -- Date of adjustment
    FOREIGN KEY (EmployeePayrollID) REFERENCES EmployeePayroll(EmployeePayrollID)
);
CREATE TABLE DirectDepositInfo (
    DepositID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to the employee
    BankName VARCHAR(100) NOT NULL,
    RoutingNumber VARCHAR(9) NOT NULL, -- Bank routing number
    AccountNumber VARCHAR(20) NOT NULL, -- Employee account number
    AccountType ENUM('Checking', 'Savings') NOT NULL,
    IsPrimary BOOLEAN DEFAULT TRUE, -- Whether this is the primary account
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
CREATE TABLE PayrollReports (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,
    PayrollPeriodID INT NOT NULL, -- Reference to PayrollPeriods
    ReportType ENUM('Summary', 'Detailed', 'Tax', 'Deductions', 'Bonuses') NOT NULL, -- Type of report
    FilePath VARCHAR(255) NOT NULL, -- Path to the stored report file (e.g., PDF or CSV)
    GeneratedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the report was generated
    GeneratedBy INT NOT NULL, -- Reference to the employee or admin who generated the report
    FOREIGN KEY (PayrollPeriodID) REFERENCES PayrollPeriods(PayrollPeriodID),
    FOREIGN KEY (GeneratedBy) REFERENCES Employees(EmployeeID)
);
CREATE TABLE ComplianceTracking (
    ComplianceID INT PRIMARY KEY AUTO_INCREMENT,
    PayrollPeriodID INT NOT NULL, -- Reference to PayrollPeriods
    ComplianceType ENUM('W-2', '1099', 'ACA', 'StateTax', 'LocalTax', 'Other') NOT NULL, -- Compliance type
    Description VARCHAR(255), -- Description of the compliance task
    DueDate DATE NOT NULL, -- When the compliance task is due
    Status ENUM('Pending', 'Completed', 'Overdue') DEFAULT 'Pending', -- Task status
    CompletedAt TIMESTAMP NULL, -- Timestamp when the task was completed
    CompletedBy INT, -- Reference to employee/admin who completed the task
    FOREIGN KEY (PayrollPeriodID) REFERENCES PayrollPeriods(PayrollPeriodID),
    FOREIGN KEY (CompletedBy) REFERENCES Employees(EmployeeID)
);
CREATE TABLE W2Forms (
    W2ID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL, -- Reference to Employees
    TaxYear YEAR NOT NULL, -- Tax year for the form
    TotalEarnings DECIMAL(10, 2) NOT NULL, -- Total earnings for the year
    FederalTaxWithheld DECIMAL(10, 2) NOT NULL, -- Federal tax withheld
    StateTaxWithheld DECIMAL(10, 2), -- State tax withheld
    SocialSecurityTax DECIMAL(10, 2), -- Social Security tax withheld
    MedicareTax DECIMAL(10, 2), -- Medicare tax withheld
    FilePath VARCHAR(255) NOT NULL, -- Path to the stored W-2 file
    IssuedDate DATE NOT NULL, -- Date the W-2 was issued
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
CREATE TABLE 1099Forms (
    FormID INT PRIMARY KEY AUTO_INCREMENT,
    ContractorID INT NOT NULL, -- Reference to Contractors (assuming a Contractors table)
    TaxYear YEAR NOT NULL, -- Tax year for the form
    TotalPayments DECIMAL(10, 2) NOT NULL, -- Total payments made to the contractor
    FederalTaxWithheld DECIMAL(10, 2), -- Federal tax withheld, if applicable
    FilePath VARCHAR(255) NOT NULL, -- Path to the stored 1099 form
    IssuedDate DATE NOT NULL, -- Date the 1099 was issued
    FOREIGN KEY (ContractorID) REFERENCES Contractors(ContractorID)
);
CREATE TABLE PayrollAuditLogs (
    AuditLogID INT PRIMARY KEY AUTO_INCREMENT,
    TableName VARCHAR(50) NOT NULL, -- Table affected by the change
    RecordID INT NOT NULL, -- ID of the affected record
    ActionType ENUM('Insert', 'Update', 'Delete') NOT NULL, -- Type of action
    ChangedBy INT NOT NULL, -- Reference to the employee/admin making the change
    ChangeTimestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When the change occurred
    ChangeDetails TEXT NOT NULL, -- JSON or text description of the changes
    FOREIGN KEY (ChangedBy) REFERENCES Employees(EmployeeID)
);
CREATE TABLE TaxFilingStatus (
    FilingID INT PRIMARY KEY AUTO_INCREMENT,
    TaxYear YEAR NOT NULL, -- Tax year for the filing
    FilingType ENUM('Federal', 'State', 'Local') NOT NULL, -- Type of filing
    Description VARCHAR(255), -- Description of the filing activity
    AmountFiled DECIMAL(10, 2) NOT NULL, -- Amount filed
    FilingDate DATE NOT NULL, -- Date the filing was made
    Status ENUM('Pending', 'Submitted', 'Approved', 'Rejected') DEFAULT 'Pending', -- Filing status
    Notes TEXT, -- Additional notes or comments
    SubmittedBy INT NOT NULL, -- Reference to employee/admin submitting the filing
    FOREIGN KEY (SubmittedBy) REFERENCES Employees(EmployeeID)
);

--Recruitment and Hiring

CREATE TABLE JobApplications (
    ApplicationID INT PRIMARY KEY AUTO_INCREMENT,
    JobPostingID INT NOT NULL,
    CandidateName VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    PhoneNumber VARCHAR(15),
    ResumeFilePath VARCHAR(255),
    ApplicationDate DATE NOT NULL,
    Status ENUM('Received', 'Screening', 'Interview', 'Offer', 'Hired', 'Rejected') DEFAULT 'Received',
    FOREIGN KEY (JobPostingID) REFERENCES JobPostings(JobPostingID)
);

CREATE TABLE JobPostings (
    JobPostingID INT PRIMARY KEY AUTO_INCREMENT,
    PositionID INT NOT NULL,
    JobTitle VARCHAR(100) NOT NULL,
    Description TEXT,
    PostingDate DATE NOT NULL,
    ClosingDate DATE,
    Status ENUM('Open', 'Closed', 'Filled') DEFAULT 'Open',
    FOREIGN KEY (PositionID) REFERENCES Positions(PositionID)
);

CREATE TABLE Contractors (
    ContractorID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15),
    CompanyName VARCHAR(100),
    ContractStartDate DATE NOT NULL,
    ContractEndDate DATE,
    RateType ENUM('Hourly', 'Fixed') NOT NULL,
    HourlyRate DECIMAL(10,2),
    FixedContractAmount DECIMAL(10,2),
    Status ENUM('Active', 'Completed', 'Terminated') DEFAULT 'Active'
);

--TIME MANAGEMENT

CREATE TABLE TimeTracking (
    TimeTrackingID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    WorkDate DATE NOT NULL,
    ClockIn DATETIME NOT NULL,
    ClockOut DATETIME,
    TotalHoursWorked DECIMAL(5,2),
    Status ENUM('Present', 'Absent', 'Late', 'PTO') NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE LeaveBalances (
    LeaveBalanceID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    LeaveType ENUM('Vacation', 'Sick', 'Personal', 'Comp Time') NOT NULL,
    TotalHoursAccrued DECIMAL(5,2) NOT NULL,
    HoursUsed DECIMAL(5,2) NOT NULL,
    RemainingHours DECIMAL(5,2) NOT NULL,
    Year INT NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);


--TRAINING
CREATE TABLE TrainingPrograms (
    ProgramID INT PRIMARY KEY AUTO_INCREMENT,
    ProgramName VARCHAR(200) NOT NULL,
    Description TEXT,
    Type ENUM('Mandatory', 'Optional', 'Professional Development', 'Leadership', 'Technical') NOT NULL,
    Duration INT, -- Duration in hours
    DeliveryMethod ENUM('In-Person', 'Online', 'Hybrid', 'Workshop', 'Conference') NOT NULL,
    CostPerEmployee DECIMAL(10,2),
    MaxParticipants INT,
    StartDate DATE,
    EndDate DATE,
    IsActive BOOLEAN DEFAULT TRUE
);

CREATE TABLE TrainingRegistrations (
    RegistrationID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    ProgramID INT NOT NULL,
    RegistrationDate DATE NOT NULL,
    Status ENUM('Registered', 'Completed', 'Cancelled', 'Pending') DEFAULT 'Registered',
    CompletionDate DATE,
    Score DECIMAL(5,2),
    Certification VARCHAR(100),
    Notes TEXT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProgramID) REFERENCES TrainingPrograms(ProgramID)
);

CREATE TABLE SkillsInventory (
    SkillID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    SkillName VARCHAR(100) NOT NULL,
    ProficiencyLevel ENUM('Beginner', 'Intermediate', 'Advanced', 'Expert') NOT NULL,
    LastAssessedDate DATE,
    CertificationStatus BOOLEAN DEFAULT FALSE,
    Notes TEXT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

--Performance and Feeback

CREATE TABLE PerformanceCycles (
    CycleID INT PRIMARY KEY AUTO_INCREMENT,
    CycleName VARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    ReviewType ENUM('Annual', 'Mid-Year', 'Quarterly') NOT NULL,
    Status ENUM('Planned', 'In Progress', 'Completed') DEFAULT 'Planned'
);

CREATE TABLE PerformanceMetrics (
    MetricID INT PRIMARY KEY AUTO_INCREMENT,
    MetricName VARCHAR(200) NOT NULL,
    Description TEXT,
    Category ENUM('Individual', 'Team', 'Departmental', 'Company-Wide') NOT NULL,
    WeightagePercentage DECIMAL(5,2)
);

CREATE TABLE PerformanceReviews (
    ReviewID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    CycleID INT NOT NULL,
    ReviewerID INT NOT NULL,
    OverallRating DECIMAL(4,2),
    RatingScale ENUM('1-5', '1-10', 'A-F') NOT NULL,
    ReviewDate DATE NOT NULL,
    Status ENUM('Draft', 'Submitted', 'Approved', 'Completed') DEFAULT 'Draft',
    ManagerComments TEXT,
    EmployeeComments TEXT,
    RecommendedActions TEXT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (CycleID) REFERENCES PerformanceCycles(CycleID),
    FOREIGN KEY (ReviewerID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE PerformanceGoals (
    GoalID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    CycleID INT NOT NULL,
    GoalType ENUM('Professional Development', 'Performance', 'Career Growth') NOT NULL,
    Description TEXT NOT NULL,
    TargetCompletionDate DATE NOT NULL,
    WeightagePercentage DECIMAL(5,2),
    Status ENUM('Not Started', 'In Progress', 'Completed', 'Partially Completed', 'Missed') DEFAULT 'Not Started',
    ActualOutcome TEXT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (CycleID) REFERENCES PerformanceCycles(CycleID)
);

CREATE TABLE CareerPaths (
    PathID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentID INT NOT NULL,
    StartPosition VARCHAR(100) NOT NULL,
    EndPosition VARCHAR(100) NOT NULL,
    TypicalProgressionYears INT,
    Description TEXT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE SuccessionPlanning (
    SuccessionID INT PRIMARY KEY AUTO_INCREMENT,
    PositionID INT NOT NULL,
    EmployeeID INT NOT NULL,
    PotentialSuccessorID INT,
    ReadinessLevel ENUM('Not Ready', 'Developing', 'Ready Soon', 'Ready Now') NOT NULL,
    DevelopmentPlan TEXT,
    TargetTransitionDate DATE,
    Status ENUM('Active', 'Potential', 'Completed') DEFAULT 'Active',
    FOREIGN KEY (PositionID) REFERENCES Positions(PositionID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (PotentialSuccessorID) REFERENCES Employees(EmployeeID)
);
--Compliance

CREATE TABLE ComplianceTrainings (
    TrainingID INT PRIMARY KEY AUTO_INCREMENT,
    TrainingName VARCHAR(200) NOT NULL,
    Description TEXT,
    Frequency ENUM('Annual', 'Biennial', 'One-Time') NOT NULL,
    MandatoryForPositions TEXT,
    RequiredCompletionDays INT,
    RegulatingBody VARCHAR(100)
);

CREATE TABLE ComplianceTracking (
    TrackingID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    TrainingID INT NOT NULL,
    CompletionDate DATE,
    ExpirationDate DATE,
    Status ENUM('Completed', 'Pending', 'Overdue') NOT NULL,
    CertificateNumber VARCHAR(100),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (TrainingID) REFERENCES ComplianceTrainings(TrainingID)
);

CREATE TABLE EthicsReportings (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,
    ReporterID INT,
    ReportedEmployeeID INT,
    ReportType ENUM('Harassment', 'Discrimination', 'Fraud', 'Misconduct', 'Other') NOT NULL,
    Description TEXT NOT NULL,
    SubmissionDate DATE NOT NULL,
    Status ENUM('Reported', 'Under Investigation', 'Resolved', 'Closed') DEFAULT 'Reported',
    InvestigationFindings TEXT,
    ResolutionDate DATE,
    FOREIGN KEY (ReporterID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ReportedEmployeeID) REFERENCES Employees(EmployeeID)
);