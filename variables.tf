variable "nics" {
  description = "NIC 정보 리스트"
  type = list(object({
    name                  = string       # NIC 이름
    description           = string       # NIC 메모
    subnet_no             = string       # Subnet ID
    access_control_groups = list(string) # ACG ID 리스트
    order                 = number       # 우선순위
  }))
}

variable "name" {
  description = "서버 이름"
  type        = string
}

variable "subnet_no" {
  description = "Subnet ID"
  type        = string
}

variable "server_image_product_code" {
  description = "서버 이미지 코드"
  type        = string
}

variable "server_product_code" {
  description = "서버 상품 코드"
  type        = string
}

variable "login_key_name" {
  description = "서버 접속 키 이름"
  type        = string
}

