create table if not exists "User" (
  UserID uuid default gen_random_uuid() primary key,
  Username varchar check (char_length(Username) >= 4 and char_length(Username) <= 20),
  Email varchar unique,
  HashPassword varchar
);

create table if not exists "PaymentMethod" (
  PaymentMethodID uuid default gen_random_uuid() primary key,
  Type varchar,
  Information text unique
);

create table if not exists "Publisher" (
  PublisherID uuid primary key,
  PaymentMethodID uuid,
  Description text,

  foreign key (PublisherID) references "User" (UserID) on delete cascade,
  foreign key (PaymentMethodID) references "PaymentMethod" (PaymentMethodID) on delete cascade
);

create table if not exists "Resource" (
  ResourceID uuid default gen_random_uuid() primary key,
  UserID uuid,
  URL text,
  type text,

  foreign key (UserID) references "User" (UserID) on delete cascade
);

create table if not exists "Game" (
  GameID uuid default gen_random_uuid() primary key,
  PublisherID uuid,
  Name text unique,
  Description text,

  foreign key (PublisherID) references "Publisher" (PublisherID) on delete cascade
);

create table if not exists "Category" (
  CategoryID uuid default gen_random_uuid() primary key,
  CategoryName varchar unique,
  IsSensitive boolean
);

create table if not exists "Game_Category" (
  GameID uuid,
  CategoryID uuid,

  primary key (GameID, CategoryID),
  foreign key (GameID) references "Game" (GameID) on delete cascade,
  foreign key (CategoryID) references "Category" (CategoryID) on delete cascade
);

create table if not exists "Game_Resource" (
  GameID uuid,
  ResourceID uuid,

  primary key (GameID, ResourceID),
  foreign key (GameID) references "Game" (GameID) on delete cascade,
  foreign key (ResourceID) references "Resource" (ResourceID) on delete cascade
);

create table if not exists "Game_Sale" (
  GameID uuid primary key,
  StartDate date,
  EndDate date check (StartDate < EndDate),
  DiscountPercentage int2 check (DiscountPercentage >= 0 and DiscountPercentage <= 100),

  foreign key (GameID) references "Game" (GameID) on delete cascade
);

create table if not exists "Forum" (
  ForumID uuid primary key,

  foreign key (ForumID) references "Game" (GameID) on delete cascade
);

create table if not exists "Post" (
  PostID uuid default gen_random_uuid() primary key,
  UserID uuid,
  ForumID uuid,
  Content text,
  Upvote int4,
  PostDate timestamp default now(),

  foreign key (UserID) references "User" (UserID) on delete cascade,
  foreign key (ForumID) references "Forum" (ForumID) on delete cascade
);

create table if not exists "Comment" (
  CommentID uuid default gen_random_uuid(),
  UserID uuid,
  ForumID uuid,
  Content text,
  Upvote int4,
  CommentDate timestamp default now(),

  primary key (CommentID),
  foreign key (UserID) references "User" (UserID) on delete cascade,
  foreign key (ForumID) references "Forum" (ForumID) on delete cascade
);

create table if not exists "Transaction" (
  TransactionID uuid default gen_random_uuid(),
  PaymentMethodID uuid,
  SenderID uuid,
  ReceiverID uuid,
  MoneyAmount int4 check (MoneyAmount > 0),
  TransactionDate timestamp default now(),

  primary key (TransactionID),
  foreign key (PaymentMethodID) references "PaymentMethod" (PaymentMethodID) on delete cascade,
  foreign key (SenderID) references "User" (UserID) on delete cascade,
  foreign key (ReceiverID) references "User" (UserID) on delete cascade
);

create table if not exists "User_Game" (
  UserID uuid,
  GameID uuid,
  status text,

  primary key (UserID, GameID),
  foreign key (GameID) references "Game" (GameID) on delete cascade,
  foreign key (UserID) references "User" (UserID) on delete cascade
);