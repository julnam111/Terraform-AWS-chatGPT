# database
#-------------

resource "aws_dynamodb_table" "city_table" {
  name           = "city_table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "name"
  range_key      = "city"

  attribute {
    name = "name"
    type = "S"
  }

  attribute {
    name = "city"
    type = "S"
  }

  tags = {
    Name = "CityTable"
  }
}

resource "aws_dynamodb_table_item" "entry_1" {
  table_name = aws_dynamodb_table.city_table.name

  hash_key   = "name"
  range_key  = "city"

  item = <<EOF
{
  "name": {"S": "Belshazzar"},
  "city": {"S": "Babylon"}
}
EOF
}

resource "aws_dynamodb_table_item" "entry_2" {
  table_name = aws_dynamodb_table.city_table.name

  hash_key   = "name"
  range_key  = "city"

  item = <<EOF
{
  "name": {"S": "Ariadne"},
  "city": {"S": "Atlantis"}
}
EOF
}