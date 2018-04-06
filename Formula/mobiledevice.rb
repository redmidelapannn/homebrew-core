class Mobiledevice < Formula
  desc "CLI for Apple's Private (Closed) Mobile Device Framework"
  homepage "https://github.com/imkira/mobiledevice"
  url "https://github.com/imkira/mobiledevice/archive/v2.0.0.tar.gz"
  sha256 "07b167f6103175c5eba726fd590266bf6461b18244d34ef6d05a51fc4871e424"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bacd67764c1f7f0febca899e03c4292c249b7246a84c533a64cd98f401d80cc6" => :sierra
    sha256 "d26b81c6b8d1bf76f45c136f0c08cde8bfa13809437fc7a6e4eed1e5c6279ba6" => :el_capitan
  end

  depends_on MaximumMacOSRequirement => :sierra

  def install
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mobiledevice", "list_devices"
  end
end
