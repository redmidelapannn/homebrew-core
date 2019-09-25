class Antibody < Formula
  desc "The fastest shell plugin manager"
  homepage "https://getantibody.github.io/"
  url "https://github.com/getantibody/antibody/archive/v4.1.2.tar.gz"
  sha256 "79e857c79cf51bff0bf42ef970a31341445911dc19cf24efb8faa01584855905"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e20c14085933c2a1c564eeff6960802d4b579d25bc2ef27c7c7181e968f181f7" => :mojave
    sha256 "b97390249e6829cfabf5f74231c941000d4a8691e70a7724992be88259ee86d9" => :high_sierra
    sha256 "df5ab98e767ac4e2a7ff7930a7fc566e0818de04191300942ac142a6e4f4a2a4" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/antibody/antibody"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "go", "build", "-ldflags", "-X main.version=#{version}"
      bin.install "antibody"
    end
  end

  test do
    # See if antibody can install a bundle correctly
    system "#{bin}/antibody", "bundle", "rupa/z"
    assert_match("rupa/z", shell_output("#{bin}/antibody list"))
  end
end
