resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = "100daysofredteam-rt-public-${var.environment}"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "100daysofredteam-rt-private-${var.environment}"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = var.private_subnet_id
  route_table_id = aws_route_table.private.id
}
