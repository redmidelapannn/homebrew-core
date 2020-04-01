class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/geek1011/kepubify/archive/v3.1.2.tar.gz"
  sha256 "69f02af0846eb5c153db73a1c07b53ba478986ca07f87af400d66e5f47699f81"
  head "https://github.com/geek1011/kepubify.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "53669dfea07d7e50684dd7d6a833fcc7c51ad5e6035e137df8bc815bcfa0c9ca" => :catalina
    sha256 "7f949ab01a86d4ffc30f735a43eed8ac1b42944095855e7457e9ff6d82604ffc" => :mojave
    sha256 "48ae83d99c298e2b1805e74a5b555d689a1cc8ae9298b14ab5c30de5df05fdf1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", "-o", bin/p,
                   "-ldflags", "-s -w -X main.version=#{version}",
                   "./cmd/#{p}"
    end

    pkgshare.install "kepub/test.epub"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", pkgshare/"test.epub"
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end
