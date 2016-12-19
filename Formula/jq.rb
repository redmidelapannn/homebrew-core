class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
  sha256 "c4d2bfec6436341113419debf479d833692cc5cdab7eb0326b5a4d4fbe9f493c"
  revision 3

  bottle do
    cellar :any
    sha256 "838eb719ab7dfa21580a987e1c1e98116cf0ddf018ee7575dc887ab770e14add" => :sierra
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma" # jq depends > 1.5

  def install
    system "autoreconf", "-iv" unless build.stable?

    # install ruby gems for generating man page
    cd "docs" do
      docs_path = `pwd`.chomp
      bundle_path = "#{docs_path}/vendor/bundle"
      ENV["GEM_HOME"] = docs_path
      ENV["GEM_PATH"] = docs_path
      ENV["BUNDLE_PATH"] = bundle_path
      system "gem", "install", "--no-document", "bundler"
      system "bin/bundle", "install"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-maintainer-mode",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
