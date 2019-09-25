class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r13.tar.gz"
  sha256 "fe99ed9785fbdc606835139c0c52c854b32b1f1449ba83567a115b21d2e882f4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "626f3e660f36c4d155ff64629838133f01d443b50576564e16f53bef6ce92135" => :mojave
    sha256 "4a33a7eb97e98c3de6b99bad9dd8901e13748f1464ee227611c088f50482570f" => :high_sierra
    sha256 "6a0e4ebed7a24fd523af5f2a9f28dd848938cb5f03df8569b52f7baf11268fd5" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["version"] = version
    (buildpath/"src/github.com/gokcehan/lf").install buildpath.children
    cd "src/github.com/gokcehan/lf" do
      system "./gen/build.sh", "-o", bin/"lf"
      prefix.install_metafiles
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
