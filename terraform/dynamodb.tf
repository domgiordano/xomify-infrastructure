
########################################
# 1. xomify-users
########################################
resource "aws_dynamodb_table" "users" {
  name           = "${var.app_name}-users"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 0
  write_capacity = 0
  hash_key       = "email"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_alias.dynamodb.target_key_arn
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "email"
    type = "S"
  }

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-users" }))

}
########################################
# 2. xomify-wrapped-history
########################################
resource "aws_dynamodb_table" "wrapped_history" {
  name           = "${var.app_name}-wrapped-history"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 0
  write_capacity = 0
  hash_key       = "email"
  range_key      = "monthKey"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_alias.dynamodb.target_key_arn
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "email"
    type = "S"
  }
  attribute {
    name = "monthKey"
    type = "S"
  }

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-wrapped-history" }))

}
########################################
# 3. xomify-release-radar-history
########################################
resource "aws_dynamodb_table" "release_radar_history" {
  name           = "${var.app_name}-release-radar-history"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 0
  write_capacity = 0
  hash_key       = "email"
  range_key      = "weekKey"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_alias.dynamodb.target_key_arn
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "email"
    type = "S"
  }
  attribute {
    name = "weekKey"
    type = "S"
  }

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-release-radar-history" }))

}

########################################
# 4. xomify-friendships
########################################
resource "aws_dynamodb_table" "friendships" {
  name           = "${var.app_name}-friendships"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 0
  write_capacity = 0
  hash_key       = "email"
  range_key      = "friendEmail"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_alias.dynamodb.target_key_arn
  }

  point_in_time_recovery {
    enabled = true
  }
  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "friendEmail"
    type = "S"
  }

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-friendships" }))
}

########################################
# 5. xomify-groups
########################################
resource "aws_dynamodb_table" "groups" {
  name           = "${var.app_name}-groups"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 0
  write_capacity = 0
  hash_key       = "groupId"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_alias.dynamodb.target_key_arn
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "groupId"
    type = "S"
  }

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-groups" }))
}

########################################
# 6. xomify-group-members
########################################
resource "aws_dynamodb_table" "group_members" {
  name           = "${var.app_name}-group-members"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 0
  write_capacity = 0
  hash_key       = "email"
  range_key      = "groupId"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_alias.dynamodb.target_key_arn
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "email"
    type = "S"
  }
  attribute {
    name = "groupId"
    type = "S"
  }

  # GSI: Lookup members by groupId
  global_secondary_index {
    name            = "groupId-email-index"
    hash_key        = "groupId"
    range_key       = "email"
    projection_type = "ALL"
  }

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-groups-members" }))
}

########################################
# 7. xomify-group-tracks
########################################
resource "aws_dynamodb_table" "group_tracks" {
  name           = "${var.app_name}-group-tracks"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 0
  write_capacity = 0
  hash_key       = "groupId"
  range_key      = "trackIdTimestamp"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_alias.dynamodb.target_key_arn
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "groupId"
    type = "S"
  }

  attribute {
    name = "trackIdTimestamp"
    type = "S"
  }

  # trackId_timestamp format: trackId#timestamp

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-group-tracks" }))
}

########################################
# 8. xomify-track-ratings
########################################
resource "aws_dynamodb_table" "track_ratings" {
  name           = "${var.app_name}-track-ratings"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 0
  write_capacity = 0
  hash_key       = "email"
  range_key      = "trackId"

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_alias.dynamodb.target_key_arn
  }

  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "trackId"
    type = "S"
  }

  tags = merge(local.standard_tags, tomap({ "name" = "${var.app_name}-track-ratings" }))
}

