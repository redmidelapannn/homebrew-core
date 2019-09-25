class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
    :tag      => "v0.7.2",
    :revision => "70bd2ae3a3476969cae3c7f921d38b130ceec648"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "372ad8c51d48a677b4c00d253a171d6d3d28a621cd32c645cba024c4a64a81d8" => :mojave
    sha256 "a5a2e4e5dfa71372ff5d0911af6ec1c5b35345d8f8d2d04d0848b0525dc41102" => :high_sierra
    sha256 "b932bb11ad3b8833dac89b91896cb8c38f12bae75d1c89bf532d38abc938c63b" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/bcicen/ctop"
    src.install buildpath.children
    src.cd do
      system "make", "build"
      bin.install "ctop"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
