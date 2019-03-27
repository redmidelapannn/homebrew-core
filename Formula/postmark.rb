class Postmark < Formula
  desc "File system benchmark from NetApp"
  homepage "https://packages.debian.org/sid/postmark"
  url "https://deb.debian.org/debian/pool/main/p/postmark/postmark_1.53.orig.tar.gz"
  sha256 "8a88fd322e1c5f0772df759de73c42aa055b1cd36cbba4ce6ee610ac5a3c47d3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c9017f95626031f01c30d59e43d27a99e4b25e02099dc3a2fda8dd518327261c" => :mojave
    sha256 "e310f3d75423cb4470c27fa093f17c9896e659a8d541cecd64043eb279328fe0" => :high_sierra
    sha256 "ab70126798dc1e67e0d1fba4ec892078af8900c811058d5525f6257b43a86b3c" => :sierra
  end

  def install
    system ENV.cc, "-o", "postmark", "postmark-#{version}.c"
    bin.install "postmark"
    man1.install "postmark.1"
  end

  test do
    (testpath/"config").write <<~EOS
      set transactions 50
      set location #{testpath}
      run
    EOS

    output = pipe_output("#{bin}/postmark #{testpath}/config")
    assert_match /(50 per second)/, output
  end
end
