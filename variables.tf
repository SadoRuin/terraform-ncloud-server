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
  default     = null
}

variable "server_product_code" {
  description = "서버 상품 코드"
  type        = string
}

variable "member_server_image_no" {
  description = "내 서버 이미지 번호"
  type        = string
  default     = null
}

variable "login_key_name" {
  description = "서버 접속 키(.pem) 이름"
  type        = string
}

variable "is_protect_server_termination" {
  description = "서버 반납 보호 여부"
  type        = bool
  default     = false
}

variable "fee_system_type_code" {
  description = "요금제 타입 (MTRAT(시간제) | FXSUM(정액제))"
  type        = string
  default     = "MTRAT"
}

variable "init_script_no" {
  description = "Init Script 번호"
  type        = string
  default     = null
}
