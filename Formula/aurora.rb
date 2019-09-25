class Aurora < Formula
  desc "Beanstalkd queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/xuri/aurora/archive/2.2.tar.gz"
  sha256 "90ac08b7c960aa24ee0c8e60759e398ef205f5b48c2293dd81d9c2f17b24ca42"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "35a06e59f6afb5f7ce63b2542dac2c1281e98cfc2cb6c6e2f88c892bf081f90b" => :mojave
    sha256 "70fc729befa1d2fe7d0be37fe7fc34b6c7fd4515b1328465775570615bb38b6b" => :high_sierra
    sha256 "a74b87ceadecb780053204371f5318260ed7f464156289889ed0eba60582235a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    aurorapath = buildpath/"src/github.com/xuri/aurora"
    aurorapath.install buildpath.children

    cd aurorapath do
      system "go", "build", "-o", bin/"aurora"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aurora -v")
  end
end
