class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=apr/apr-1.7.0.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.0.tar.bz2"
  sha256 "e2e148f0b2e99b8e5c6caa09f6d4fb4dd3e83f744aa72a952f94f5a14436f7ea"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c031ad91f52dfc2515b3f52ae70e6f24bf0f37aa1b8f32c6ab1c2ce3c2ade9ac" => :catalina
    sha256 "78bbccb8cc801401e8938ff6b8930466de596d4e1dcc5e7e96f9b15fd1405c10" => :mojave
    sha256 "0707556550b3ce2bc8e8e432e7b429c58bfb9c12f7561781d6026ca2f7b6f981" => :high_sierra
  end

  keg_only :provided_by_macos, "Apple's CLT package contains apr"

  def install
    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv

    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Stick it in libexec otherwise it pollutes lib with a .exp file.
    system "./configure", "--prefix=#{libexec}"
    system "make", "install"
    bin.install_symlink Dir["#{libexec}/bin/*"]

    rm Dir[libexec/"lib/*.la"]

    # No need for this to point to the versioned path.
    inreplace libexec/"bin/apr-1-config", libexec, opt_libexec
  end

  test do
    assert_match opt_libexec.to_s, shell_output("#{bin}/apr-1-config --prefix")
  end
end
