variable "network_interfaces" {
  description = "NIC 정보 리스트"
  type = list(object({
    name                  = string       # NIC 이름
    description           = string       # NIC 메모
    subnet_id             = string       # Subnet ID
    access_control_groups = list(string) # ACG ID 리스트
    order                 = number       # 우선순위
  }))
}

variable "name" {
  description = "서버 이름"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "server_image_name" {
  description = "서버 이미지 이름"
  type        = string
  default     = null
}

variable "member_server_image_name" {
  description = "내 서버 이미지 이름"
  type        = string
  default     = null
}

variable "product_generation" {
  description = "서버 세대 (G1 | G2)"
  type        = string
}

variable "product_type" {
  description = "서버 타입 (High CPU | Standard | High Memory | CPU Intensive | GPU | BareMetal)"
  type        = string
}

variable "product_name" {
  description = "서버 스펙 이름"
  type        = string
}

variable "login_key_name" {
  description = "서버 접속 키(.pem) 이름"
  type        = string
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

variable "is_associate_public_ip" {
  description = "Public IP 할당 여부"
  type        = bool
  default     = false
}

variable "is_protect_server_termination" {
  description = "서버 반납 보호 여부"
  type        = bool
  default     = false
}

variable "is_encrypted_base_block_storage_volume" {
  description = "기본 블록 스토리지 볼륨 암호화 여부"
  type        = bool
  default     = false
}

variable "additional_block_storages" {
  description = "추가 블록 스토리지 정보 리스트"
  type = list(object({
    name                           = string           # 블록 스토리지 이름
    description                    = string           # 블록 스토리지 설명
    size                           = number           # 블록 스토리지 크기 (GB)
    disk_detail_type               = optional(string) # 블록 스토리지 디스크 타입 (SSD | HDD)
    stop_instance_before_detaching = optional(bool)   # 블록 스토리지 제거 전 서버 중지 여부
  }))
  default = []
}
