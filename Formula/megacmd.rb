class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.014.tar.gz"
  sha256 "d49ae15aee11a8174d71102830fb499c9eeae7abd6da1d8ac3b308390c0afac5"
  head "https://github.com/t3rm1n4l/megacmd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b593dd9c4f981d6a64516e4cf04f3d62aa8b624badc1684438f38fae74d83c3" => :mojave
    sha256 "73adefeb74c5ca7c7207ed2b8dda70e74c95dcdac1cff4f6fdada49f4edf65a1" => :high_sierra
    sha256 "cc492608bbfbf2f12a6ad424de9927e8d25038fb9b40d1058383656c09f38f60" => :sierra
    sha256 "9e1449cd025d40e6669cfc0941f81c857de87b436fe48138b3b2c7db33754162" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/t3rm1n4l/megacmd").install buildpath.children
    cd "src/github.com/t3rm1n4l/megacmd" do
      system "go", "build", "-o", bin/"megacmd"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"megacmd", "--version"
  end
end
