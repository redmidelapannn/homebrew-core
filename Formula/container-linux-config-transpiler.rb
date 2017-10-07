class ContainerLinuxConfigTranspiler < Formula
  desc "Convert a Container Linux Config into Ignition"
  url "https://github.com/coreos/container-linux-config-transpiler/archive/v0.5.0.tar.gz"
  homepage "https://github.com/coreos/container-linux-config-transpiler"
  sha256 "172e44796d39ec117584e121e73194cbcb56701407badc1899cea4607a343e15"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e9fe5ad4a4549ca25adb88df2dfdaa53af25355c007f53eb483e45b7eb0a99c" => :high_sierra
    sha256 "e24d059b1513f69a57a0ca9636b723466a421e0c3322adca6fa7e0cb0c8d5544" => :sierra
    sha256 "d4c0b3326021eb728cba00210841e1b0607418bdec6aec3e34f3fb62904242ba" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "make", "all"
    bin.install "./bin/ct"
  end

  test do
    system "#{bin}/ct", "--help"
  end
end
