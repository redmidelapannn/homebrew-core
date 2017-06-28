class Phantomjs < Formula
  desc "Headless WebKit scriptable with a JavaScript API"
  homepage "http://phantomjs.org/"
  head "https://github.com/ariya/phantomjs.git"

  stable do
    url "https://github.com/ariya/phantomjs.git",
        :tag => "2.1.1",
        :revision => "d9cda3dcd26b0e463533c5cc96e39c0f39fc32c1"

    # Fixes build.py for non-standard Homebrew prefixes.  Applied
    # upstream, can be removed in next release.
    patch do
      url "https://github.com/ariya/phantomjs/commit/6090f5457d2051ab374264efa18f655fa3e15e79.diff?full_index=1"
      sha256 "6ff047216fa76c2350f8fd20497b1264904eda0d6cade9bf2ebb3843740cd03f"
    end
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "d7cbcd50e6b5951e4bf999d67f88b50d62a1e5f4377810910a45318e75dc9619" => :sierra
    sha256 "afbe172bc9777294caf5efc0b0fcc69fbee42bf2da69c20504a2911e7b1be68a" => :el_capitan
    sha256 "0c69e2ae587aa9e44cbfdfcc72f72df2845906ec2938dae1ef67d536cd9ce980" => :yosemite
  end

  depends_on MinimumMacOSRequirement => :lion
  depends_on :xcode => :build
  depends_on "openssl"

  def install
    ENV["OPENSSL"] = Formula["openssl"].opt_prefix
    system "./build.py", "--confirm", "--jobs", ENV.make_jobs
    bin.install "bin/phantomjs"
    pkgshare.install "examples"
  end

  test do
    path = testpath/"test.js"
    path.write <<-EOS
      console.log("hello");
      phantom.exit();
    EOS

    assert_equal "hello", shell_output("#{bin}/phantomjs #{path}").strip
  end
end
