-- Product Master Data
CREATE TABLE ProductCategories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL,
    ParentCategoryID INT,
    Description TEXT,
    FOREIGN KEY (ParentCategoryID) REFERENCES ProductCategories(CategoryID)
);

CREATE TABLE Brands (
    BrandID INT PRIMARY KEY AUTO_INCREMENT,
    BrandName VARCHAR(100) NOT NULL UNIQUE,
    Manufacturer VARCHAR(100),
    CountryOfOrigin VARCHAR(50),
    ContactEmail VARCHAR(100),
    ContactPhone VARCHAR(20)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(200) NOT NULL,
    BrandID INT NOT NULL,
    CategoryID INT NOT NULL,
    UPC VARCHAR(20) UNIQUE NOT NULL,
    SKU VARCHAR(50) UNIQUE NOT NULL,
    Description TEXT,
    RetailPrice DECIMAL(10,2) NOT NULL,
    CostPrice DECIMAL(10,2) NOT NULL,
    Weight DECIMAL(8,2), -- in pounds
    Dimensions VARCHAR(100), -- e.g., "10x5x3"
    ShelfLife INT, -- in days
    IsPerishable BOOLEAN DEFAULT FALSE,
    IsHazardous BOOLEAN DEFAULT FALSE,
    TaxCategory ENUM('Standard', 'Reduced', 'Zero', 'Exempt') DEFAULT 'Standard',
    Status ENUM('Active', 'Discontinued', 'Seasonal') DEFAULT 'Active',
    FOREIGN KEY (BrandID) REFERENCES Brands(BrandID),
    FOREIGN KEY (CategoryID) REFERENCES ProductCategories(CategoryID)
);

-- Inventory Management
CREATE TABLE Warehouses (
    WarehouseID INT PRIMARY KEY AUTO_INCREMENT,
    WarehouseName VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(20) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    Capacity DECIMAL(10,2), -- in square feet
    StorageType ENUM('Ambient', 'Refrigerated', 'Frozen', 'Hazardous') NOT NULL
);

CREATE TABLE InventoryLevels (
    InventoryID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL,
    WarehouseID INT NOT NULL,
    CurrentStock INT NOT NULL,
    ReorderPoint INT NOT NULL,
    MaxStockLevel INT NOT NULL,
    SafetyStockLevel INT NOT NULL,
    LastStocktakeDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    UNIQUE (ProductID, WarehouseID)
);

-- Supplier Management
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierName VARCHAR(200) NOT NULL,
    ContactPerson VARCHAR(100),
    Address VARCHAR(200) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(20) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    PaymentTerms ENUM('Net 30', 'Net 60', 'Net 90', 'COD') NOT NULL,
    CreditLimit DECIMAL(10,2),
    Status ENUM('Active', 'Suspended', 'Inactive') DEFAULT 'Active'
);

CREATE TABLE SupplierProducts (
    SupplierProductID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierID INT NOT NULL,
    ProductID INT NOT NULL,
    SupplierProductCode VARCHAR(50),
    LeadTime INT, -- in days
    MinOrderQuantity INT NOT NULL,
    PreferredSupplier BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    UNIQUE (SupplierID, ProductID)
);

-- Purchasing and Procurement
CREATE TABLE PurchaseOrders (
    PurchaseOrderID INT PRIMARY KEY AUTO_INCREMENT,
    SupplierID INT NOT NULL,
    WarehouseID INT NOT NULL,
    OrderDate DATE NOT NULL,
    ExpectedDeliveryDate DATE,
    ActualDeliveryDate DATE,
    TotalOrderValue DECIMAL(10,2) NOT NULL,
    Status ENUM('Pending', 'Partial', 'Completed', 'Cancelled') DEFAULT 'Pending',
    Notes TEXT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID)
);

CREATE TABLE PurchaseOrderItems (
    PurchaseOrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    PurchaseOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    OrderedQuantity INT NOT NULL,
    UnitCost DECIMAL(10,2) NOT NULL,
    ReceivedQuantity INT DEFAULT 0,
    FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrders(PurchaseOrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Logistics and Transportation
CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY AUTO_INCREMENT,
    PurchaseOrderID INT,
    OriginWarehouseID INT NOT NULL,
    DestinationWarehouseID INT NOT NULL,
    ShipmentDate DATETIME NOT NULL,
    EstimatedArrivalDate DATETIME,
    ActualArrivalDate DATETIME,
    TransportMethod ENUM('Truck', 'Rail', 'Air', 'Sea', 'Courier') NOT NULL,
    CarrierName VARCHAR(100),
    TrackingNumber VARCHAR(50),
    Status ENUM('Pending', 'In Transit', 'Delivered', 'Delayed', 'Lost') DEFAULT 'Pending',
    FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrders(PurchaseOrderID),
    FOREIGN KEY (OriginWarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (DestinationWarehouseID) REFERENCES Warehouses(WarehouseID)
);

CREATE TABLE ShipmentItems (
    ShipmentItemID INT PRIMARY KEY AUTO_INCREMENT,
    ShipmentID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    FOREIGN KEY (ShipmentID) REFERENCES Shipments(ShipmentID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Demand Forecasting and Replenishment
CREATE TABLE DemandForecasts (
    ForecastID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL,
    ForecastDate DATE NOT NULL,
    ForecastPeriod ENUM('Daily', 'Weekly', 'Monthly', 'Quarterly') NOT NULL,
    PredictedDemand INT NOT NULL,
    ConfidenceLevel DECIMAL(5,2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Quality Control
CREATE TABLE QualityInspections (
    InspectionID INT PRIMARY KEY AUTO_INCREMENT,
    PurchaseOrderID INT NOT NULL,
    InspectionDate DATETIME NOT NULL,
    InspectorName VARCHAR(100),
    Status ENUM('Passed', 'Failed', 'Partial') NOT NULL,
    DefectRate DECIMAL(5,2),
    Notes TEXT,
    FOREIGN KEY (PurchaseOrderID) REFERENCES PurchaseOrders(PurchaseOrderID)
);

-- Product Returns and Reverse Logistics
CREATE TABLE ProductReturns (
    ReturnID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL,
    WarehouseID INT NOT NULL,
    ReturnDate DATETIME NOT NULL,
    Reason ENUM('Defective', 'Wrong Item', 'Customer Return', 'Overstock', 'Damaged') NOT NULL,
    Quantity INT NOT NULL,
    Status ENUM('Received', 'Inspected', 'Restocked', 'Scrapped') DEFAULT 'Received',
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID)
);

-- Pricing and Cost Management
CREATE TABLE ProductCostHistory (
    CostHistoryID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL,
    SupplierID INT NOT NULL,
    EffectiveDate DATE NOT NULL,
    PreviousCost DECIMAL(10,2),
    NewCost DECIMAL(10,2) NOT NULL,
    Reason VARCHAR(200),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);


-- Stores Table
CREATE TABLE Stores (
    StoreID INT PRIMARY KEY AUTO_INCREMENT,
    StoreName VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    City VARCHAR(100) NOT NULL,
    State VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(20) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    StoreType ENUM('Supercenter', 'Neighborhood Market', 'Express', 'Distribution Center') NOT NULL,
    StoreSize DECIMAL(10,2), -- in square feet
    OpeningDate DATE,
    Status ENUM('Active', 'Closed', 'Renovating') DEFAULT 'Active'
);

-- Store-Level Inventory
CREATE TABLE StoreInventoryLevels (
    StoreInventoryID INT PRIMARY KEY AUTO_INCREMENT,
    StoreID INT NOT NULL,
    ProductID INT NOT NULL,
    CurrentStock INT NOT NULL,
    ReorderPoint INT NOT NULL,
    MaxStockLevel INT NOT NULL,
    SafetyStockLevel INT NOT NULL,
    LastStocktakeDate DATE,
    DisplayLocation VARCHAR(100), -- Aisle, shelf, end-cap location
    IsDisplayItem BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    UNIQUE (StoreID, ProductID)
);

-- Store Transfer Requests
CREATE TABLE StoreTransfers (
    TransferID INT PRIMARY KEY AUTO_INCREMENT,
    SourceStoreID INT NOT NULL,
    DestinationStoreID INT NOT NULL,
    RequestDate DATETIME NOT NULL,
    ApprovalDate DATETIME,
    TransferDate DATETIME,
    Status ENUM('Requested', 'Approved', 'In Transit', 'Completed', 'Cancelled') DEFAULT 'Requested',
    RequestedBy VARCHAR(100),
    Notes TEXT,
    FOREIGN KEY (SourceStoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (DestinationStoreID) REFERENCES Stores(StoreID)
);

-- Store Transfer Items
CREATE TABLE StoreTransferItems (
    TransferItemID INT PRIMARY KEY AUTO_INCREMENT,
    TransferID INT NOT NULL,
    ProductID INT NOT NULL,
    RequestedQuantity INT NOT NULL,
    TransferredQuantity INT DEFAULT 0,
    FOREIGN KEY (TransferID) REFERENCES StoreTransfers(TransferID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Store-Level Sales Tracking
CREATE TABLE StoreSales (
    SalesID INT PRIMARY KEY AUTO_INCREMENT,
    StoreID INT NOT NULL,
    ProductID INT NOT NULL,
    SaleDate DATE NOT NULL,
    QuantitySold INT NOT NULL,
    TotalRevenue DECIMAL(10,2) NOT NULL,
    DailySalesPrice DECIMAL(10,2), -- Price at time of sale
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Inventory Adjustments Tracking
CREATE TABLE InventoryAdjustments (
    AdjustmentID INT PRIMARY KEY AUTO_INCREMENT,
    StoreID INT,
    WarehouseID INT,
    ProductID INT NOT NULL,
    AdjustmentDate DATETIME NOT NULL,
    AdjustmentType ENUM('Damage', 'Theft', 'Miscount', 'Write-Off', 'Cycle Count', 'Return', 'Promotion') NOT NULL,
    QuantityAdjusted INT NOT NULL,
    Reason TEXT,
    AdjustedBy VARCHAR(100),
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Seasonal and Promotional Inventory Tracking
CREATE TABLE PromotionalInventory (
    PromotionID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    PromotionType ENUM('Seasonal', 'Holiday', 'Clearance', 'New Product Launch', 'Special Event') NOT NULL,
    DiscountPercentage DECIMAL(5,2),
    InitialInventoryQuantity INT NOT NULL,
    ReservedInventoryQuantity INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Expiration and Batch Tracking
CREATE TABLE BatchInventory (
    BatchID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL,
    BatchNumber VARCHAR(50) NOT NULL,
    ManufactureDate DATE NOT NULL,
    ExpirationDate DATE,
    ReceiptDate DATE NOT NULL,
    InitialQuantity INT NOT NULL,
    RemainingQuantity INT NOT NULL,
    WarehouseID INT,
    StoreID INT,
    Status ENUM('Active', 'Expired', 'Recalled') DEFAULT 'Active',
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    FOREIGN KEY (StoreID) REFERENCES Stores(StoreID)
);

-- Inventory Forecast and Predictive Analytics
CREATE TABLE InventoryForecastMetrics (
    ForecastMetricID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL,
    ForecastDate DATE NOT NULL,
    HistoricalSalesAverage DECIMAL(10,2),
    SeasonalityFactor DECIMAL(5,2),
    PredictedDemand INT NOT NULL,
    RecommendedStockLevel INT NOT NULL,
    StockoutRisk DECIMAL(5,2),
    OverstockRisk DECIMAL(5,2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Inventory Movement Tracking
CREATE TABLE InventoryMovement (
    MovementID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL,
    SourceLocationID INT NOT NULL,
    DestinationLocationID INT NOT NULL,
    SourceLocationType ENUM('Warehouse', 'Store', 'Supplier', 'Customer') NOT NULL,
    DestinationLocationType ENUM('Warehouse', 'Store', 'Supplier', 'Customer') NOT NULL,
    MovementDate DATETIME NOT NULL,
    Quantity INT NOT NULL,
    MovementType ENUM('Transfer', 'Sale', 'Return', 'Restock', 'Redistribution') NOT NULL,
    RelatedDocumentID INT,
    Notes TEXT,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);