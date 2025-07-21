create table if not exists "User" (
  UserID uuid default gen_random_uuid(),
  Username varchar,
  Email varchar unique,
  HashPassword varchar,

  primary key (UserID)
);

create table if not exists "PaymentMethod" (
  PaymentMethodID uuid default gen_random_uuid(),
  Type varchar,
  Information text,

  primary key (PaymentMethodID)
);

create table if not exists "Publisher" (
  PublisherID uuid,
  PaymentMethodID uuid,
  Description text,

  primary key (PublisherID),
  foreign key (PublisherID) references "User" (UserID) on delete set null,
  foreign key (PaymentMethodID) references "PaymentMethod" (PaymentMethodID) on delete set null
);

create table if not exists "Resource" (
  ResourceID uuid default gen_random_uuid(),
  UserID uuid,
  URL text,

  primary key (ResourceID),
  foreign key (UserID) references "User" (UserID) on delete set null
);

create table if not exists "Game" (
  GameID uuid default gen_random_uuid(),
  PublisherID uuid,
  Name varchar,
  Description text,
  SaleInformation text,

  primary key (GameID),
  foreign key (PublisherID) references "Publisher" (PublisherID) on delete set null
);

create table if not exists "Category" (
  CategoryID uuid default gen_random_uuid(),
  CategoryName varchar,
  IsSensitive boolean,

  primary key (CategoryID)
);

create table if not exists "Game_Category" (
  GameID uuid,
  CategoryID uuid,

  primary key (GameID, CategoryID),
  foreign key (GameID) references "Game" (GameID) on delete set null,
  foreign key (CategoryID) references "Category" (CategoryID) on delete set null
);

create table if not exists "Forum" (
  ForumID uuid,

  primary key (ForumID),
  foreign key (ForumID) references "Game" (GameID) on delete set null
);

create table if not exists "Post" (
  PostID uuid default gen_random_uuid(),
  UserID uuid,
  ForumID uuid,
  Content text,
  Upvote int4,
  PostDate timestamp default now(),

  primary key (PostID),
  foreign key (UserID) references "User" (UserID) on delete set null,
  foreign key (ForumID) references "Forum" (ForumID) on delete set null
);

create table if not exists "Comment" (
  CommentID uuid default gen_random_uuid(),
  UserID uuid,
  ForumID uuid,
  Content text,
  Upvote int4,
  CommentDate timestamp default now(),

  primary key (CommentID),
  foreign key (UserID) references "User" (UserID) on delete set null,
  foreign key (ForumID) references "Forum" (ForumID) on delete set null
);

create table if not exists "Transaction" (
  TransactionID uuid default gen_random_uuid(),
  PaymentMethodID uuid,
  SenderID uuid,
  ReceiverID uuid,
  MoneyAmount int4,
  TransactionDate timestamp default now(),

  primary key (TransactionID),
  foreign key (PaymentMethodID) references "PaymentMethod" (PaymentMethodID) on delete set null,
  foreign key (SenderID) references "User" (UserID) on delete set null,
  foreign key (ReceiverID) references "User" (UserID) on delete set null
);
