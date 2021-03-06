#  vim:ts=2:sts=2:sw=2:et
#
#  Author: Hari Sekhon
#  Date: 2021-03-04 18:19:03 +0000 (Thu, 04 Mar 2021)
#
#  https://github.com/HariSekhon/terraform
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

# ============================================================================ #
#               C l o u d f l a r e   F i r e w a l l   R u l e s
# ============================================================================ #

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/firewall_rule

# Permit Pingdom health check probe addresses to access private sites to test them

locals {

  # obtained from the Cloudflare API:
  #
  #   cloudflare_zones.sh
  #
  # XXX: Edit
  zone_id = "..."

  # source IPs copied from:
  #
  #   https://my.pingdom.com/app/probes/ipv4
  #
  #   https://documentation.solarwinds.com/en/Success_Center/pingdom/content/topics/pingdom-probe-servers-ip-addresses.htm
  #
  # TODO: if I could find a JSON API endpoint exposing these it might be better to query it and inject the IPs dynamically, similar to atlassian_cidr_ipv4.tf
  pingdom_IPs = <<EOT
5.172.196.188
13.232.220.164
23.22.2.46
23.83.129.219
23.92.127.2
23.106.37.99
23.111.152.74
23.111.159.174
27.122.14.7
37.252.231.50
43.225.198.122
43.229.84.12
46.20.45.18
46.165.195.139
46.246.122.10
50.2.185.66
50.16.153.186
50.23.28.35
52.0.204.16
52.24.42.103
52.48.244.35
52.52.34.158
52.52.95.213
52.52.118.192
52.57.132.90
52.59.46.112
52.59.147.246
52.62.12.49
52.63.142.2
52.63.164.147
52.63.167.55
52.67.148.55
52.73.209.122
52.89.43.70
52.194.115.181
52.197.31.124
52.197.224.235
52.198.25.184
52.201.3.199
52.209.34.226
52.209.186.226
52.210.232.124
54.68.48.199
54.70.202.58
54.94.206.111
64.237.49.203
64.237.55.3
66.165.229.130
66.165.233.234
72.46.130.18
72.46.131.10
76.72.167.90
76.72.167.154
76.72.172.208
76.164.234.106
76.164.234.170
82.103.136.16
82.103.139.165
82.103.145.126
83.170.113.210
85.195.116.134
89.163.146.247
89.163.242.206
94.75.211.73
94.75.211.74
94.247.174.83
95.141.32.92
95.141.37.2
96.47.225.18
103.47.211.210
104.129.24.154
104.129.30.18
109.123.101.103
148.72.170.233
148.72.171.17
151.106.52.134
162.208.48.94
162.218.67.34
162.253.128.178
168.1.203.40
169.51.2.18
169.56.174.151
172.241.112.86
173.248.147.18
173.254.206.242
174.34.156.130
175.45.132.20
178.255.152.2
178.255.153.2
179.50.12.212
184.75.208.210
184.75.209.18
184.75.210.90
184.75.210.226
184.75.214.66
184.75.214.98
184.173.45.162
185.39.146.214
185.39.146.215
185.70.76.23
185.93.3.92
185.136.156.82
185.152.65.167
185.180.12.65
185.246.208.82
188.172.252.34
190.3.174.134
196.240.207.18
196.244.191.18
196.245.151.42
199.87.228.66
200.58.101.248
201.33.21.5
207.244.80.239
209.58.139.193
209.58.139.194
213.198.67.206
EOT

}

resource "cloudflare_filter" "pingdom" {
  zone_id     = local.zone_id
  description = "Pingdom IPs"
  expression  = "(ip.src in {${local.pingdom_IPs}})"
}

resource "cloudflare_firewall_rule" "pingdom" {
  zone_id     = local.zone_id
  description = "Pingdom"
  filter_id   = cloudflare_filter.pingdom.id
  action      = "allow"
}
