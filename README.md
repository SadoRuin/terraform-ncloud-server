# NCP Server Terraform module

네이버 클라우드 플랫폼의 Server 모듈입니다.

## Table of Contents

- [Usage](#usage)
- [Resources](#resources)
  - [Server](#server)
  - [Network Interface](#network-interface)
  - [Public IP](#public-ip)
  - [Block Storage](#block-storage)
- [Inputs](#inputs)
  - [Network Interface Inputs](#network-interface-inputs)
  - [Block Storage Inputs](#block-storage-inputs)
- [Outputs](#outputs)
- [Requirements](#requirements)
- [Providers](#providers)

## [Usage](#table-of-contents)

```hcl
module "tf_test_web_svr" {
  source = "<THIS REPOSITORY URL>"

  count = 1

  name              = "tf-test-web-svr-${format("%02d", count.index + 1)}"
  subnet_id         = module.tf_test_vpc.subnets["tf-test-web-sbn"].id
  server_image_name = "Rocky Linux 8.8"
  # member_server_image_name = "test-web"
  product_generation = "G2"
  product_type       = "High CPU"
  product_name       = "vCPU 2EA, Memory 4GB, Disk 50GB"
  login_key_name     = "<YOUR LOGINKEY>"

  network_interfaces = [
    {
      subnet_id             = module.tf_test_vpc.subnets["tf-test-web-sbn"].id
      access_control_groups = [module.tf_test_vpc.acgs["tf-test-web-svr-acg"].id]
      order                 = 0
    }
  ]

  is_associate_public_ip = true

  additional_block_storages = []
}
```

## [Resources](#table-of-contents)

### [Server](#table-of-contents)

서버 생성시 필요한 Server Image와 Product 입력 값들은 [terraform-ncloud-docs](https://github.com/NaverCloudPlatform/terraform-ncloud-docs/blob/main/docs/server_image_product.md)에서 **대부분 확인 가능**

<!-- prettier-ignore -->
| Name | Type |
|------|------|
| [ncloud_server.this](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs/resources/server) | resource |
| [ncloud_server_image.server_image](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs/data-sources/server_image) | data |
| [ncloud_member_server_image.member_server_image](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs/data-sources/member_server_image) | data |
| [ncloud_server_product.server_product](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs/data-sources/server_product) | data |

### [Network Interface](#table-of-contents)

<!-- prettier-ignore -->
| Name | Type |
|------|------|
| [ncloud_network_interface.this](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs/resources/network_interface) | resource |

### [Public IP](#table-of-contents)

<!-- prettier-ignore -->
| Name | Type |
|------|------|
| [ncloud_public_ip.this](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs/resources/public_ip) | resource |

### [Block Storage](#table-of-contents)

<!-- prettier-ignore -->
| Name | Type |
|------|------|
| [ncloud_block_storage.this](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest/docs/resources/block_storage) | resource |

## [Inputs](#table-of-contents)

<!-- prettier-ignore -->
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | 서버 이름 | `string` | `null` | no |
| subnet_id | Subnet ID | `string` | - | yes |
| server_image_name | 서버 이미지 이름 (내 서버 이미지와 둘 중 하나만 사용) | `string` | `null` | no |
| member_server_image_name | 내 서버 이미지 이름 (서버 이미지와 둘 중 하나만 사용) | `string` | `null` | no |
| product_generation | 서버 세대 (G1 \| G2) | `string` | - | yes |
| product_type | 서버 타입 (High CPU \| Standard \| High Memory \| CPU Intensive \| GPU) | `string` | - | yes |
| product_name | 서버 스펙 이름 | `string` | - | yes |
| login_key_name | 서버 접속 키(.pem) 이름 | `string` | - | yes |
| fee_system_type_code | 요금제 타입 (MTRAT(시간제) \| FXSUM(정액제)) | `string` | `null` | no |
| init_script_no | Init Script 번호 | `string` | `null` | no |
| [network_interfaces](#network-interface-inputs) | NIC 정보 리스트 | <pre>list(object({<br>  name                  = optional(string)<br>  description           = optional(string)<br>  private_ip            = optional(string)<br>  subnet_id             = string<br>  access_control_groups = list(string)<br>  order                 = number<br>}))</pre> | - | yes |
| is_associate_public_ip | Public IP 할당 여부 | `bool` | `false` | no |
| is_protect_server_termination | 서버 반납 보호 여부 | `bool` | `null` | no |
| is_encrypted_base_block_storage_volume | 기본 블록 스토리지 볼륨 암호화 여부 | `bool` | `null` | no |
| [additional_block_storages](#block-storage-inputs) | 추가 블록 스토리지 정보 리스트 | <pre>list(object({<br>  name                           = string<br>  description                    = optional(string)<br>  size                           = number<br>  disk_detail_type               = optional(string)<br>  stop_instance_before_detaching = optional(bool)<br>}))</pre> | `[]` | no |

### [Network Interface Inputs](#table-of-contents)

<!-- prettier-ignore -->
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | NIC 이름 | `string` | - | no |
| description | NIC 메모 | `string` | - | no |
| private_ip | NIC에 할당할 사설 IP | `string` | - | no |
| subnet_id | Subnet ID | `string` | - | yes |
| access_control_groups | ACG ID 리스트 | `list(string)` | - | yes |
| order | 우선순위 (0 부터 시작) | `number` | - | yes |

### [Block Storage Inputs](#table-of-contents)

<!-- prettier-ignore -->
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | 블록 스토리지 이름 | `string` | - | yes |
| description | 블록 스토리지 메모 | `string` | - | no |
| size | 블록 스토리지 크기 (GB) | `number` | - | yes |
| disk_detail_type | 블록 스토리지 디스크 타입 (SSD | HDD) | `string` | - | no |
| stop_instance_before_detaching | 블록 스토리지 제거 전 서버 중지 여부 | `bool` | - | no |

## [Outputs](#table-of-contents)

<!-- prettier-ignore -->
| Name | Description | Key값 (Map 형식) |
|------|-------------|-----------------|
| server | 서버 리소스 출력 | - |
| network_interfaces | Network Interface 리소스들을 Map형식으로 출력 | `"NIC 우선순위"` |
| public_ip | 서버 Public IP 주소 출력 | - |
| block_storages | Block Storage 리소스들을 Map형식으로 출력 | `"블록 스토리지 이름"` |

## [Requirements](#table-of-contents)

<!-- prettier-ignore -->
| Name | Version |
|------|---------|
| [terraform](https://developer.hashicorp.com/terraform/install) | >= 1.0    |
| [ncloud](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest) | >= 2.3.18 |

## [Providers](#table-of-contents)

<!-- prettier-ignore -->
| Name | Version |
|------|---------|
| [ncloud](https://registry.terraform.io/providers/NaverCloudPlatform/ncloud/latest) | >= 2.3.18 |
