class OsxIso < Formula
  desc "Create a bootable ISO of OS X / macOS, from the installation app file"
  homepage "https://github.com/busterc/osx-iso"
  url "https://github.com/busterc/osx-iso/archive/3.0.0.tar.gz"
  sha256 "65949e58ef68320cb62fb22341fccde3dabb9767d52a5ab00a2aab7f056b5874"
  head "https://github.com/busterc/osx-iso.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "69760f30ef0b6f49380382d9904ab0cc54e52663b39440aa438fac8f81fc6a95" => :high_sierra
    sha256 "69760f30ef0b6f49380382d9904ab0cc54e52663b39440aa438fac8f81fc6a95" => :sierra
    sha256 "69760f30ef0b6f49380382d9904ab0cc54e52663b39440aa438fac8f81fc6a95" => :el_capitan
  end

  def install
    bin.install "osxiso"
  end

  test do
    File.exist?("#{bin}/osxiso")
  end
end
