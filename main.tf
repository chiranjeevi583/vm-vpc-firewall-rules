provider "google" {
 project = "gcp-dev-space"
 region = "us-central1"
 zone = "us-central1-b"
}
resource "google_compute_network" "vpc_network" {
 name = "my-vpc1"
 auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnet" {
 name = "my-subnet1"
 ip_cidr_range = "10.10.0.0/24"
 region = "us-central1"
 network = google_compute_network.vpc_network.id
}
resource "google_compute_firewall" "firewall" {
 name = "allow-ssh-https"
 network = google_compute_network.vpc_network.name
 allow {
 protocol = "tcp"
 ports = ["22", "80"]
 }
 source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_instance" "vm_instance" {
 name = "my-vm1"
 machine_type = "e2-medium"
 zone = "us-central1-a"
 boot_disk {
 initialize_params {
 image = "debian-cloud/debian-11"
 }
 }
 network_interface {
 network = google_compute_network.vpc_network.name
 subnetwork = google_compute_subnetwork.subnet.name
 access_config {
 // Enables external IP
 }
 }
 tags = ["http-server", "ssh"]
}
