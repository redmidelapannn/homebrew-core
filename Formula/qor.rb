class Qor < Formula
  desc "Cli v2 (using Go)"
  homepage "https://github.com/Qordobacode/Cli-v2"
  url "https://github.com/Qordobacode/Cli-v2/archive/version-0.2.tar.gz"
  sha256 "6e5f4e1a1a78c22a191101fd99259d0bbec0edde904b164e38edec129b8caaf4"
  head "https://github.com/Qordobacode/Cli-v2.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7cb156658ed56cf10631da9df85964ff7027943f98fd2957839a9ff890689d9" => :mojave
    sha256 "9b2a681b5075cec75e7aecae399d5d957119c99c9b86d9731475406459bae85b" => :high_sierra
    sha256 "42977a075052160d644f10c336ddd773c189d07fcd14ec44ab05faa5913bafba" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/qordobacode/cli-v2"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", "#{bin}/qor"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "Qordoba Cli v4.0", shell_output("#{bin}/qor --version")
  end
end