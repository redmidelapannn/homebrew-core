class Sord < Formula
  desc "C library for storing RDF data in memory"
  homepage "https://drobilla.net/software/sord/"
  url "https://download.drobilla.net/sord-0.16.4.tar.bz2"
  sha256 "b15998f4e7ad958201346009477d6696e90ee5d3e9aff25e7e9be074372690d7"

  bottle do
    cellar :any
    sha256 "7cdaa246d22171440011a68d047d3e6a266a89581935af789743b455c922fda6" => :catalina
    sha256 "d9fb150f83839e9179f5a011cba23885d6fd369912d876b066ab545eff993777" => :mojave
    sha256 "c51813aa91714be7ff72372606538ccf028f3019a2e3b1c9eb1af184d925cd2c" => :high_sierra
    sha256 "cdc2488f62b363e161df7412fc459fc4b6aa564d5b7d92c841e71d462629751a" => :sierra
    sha256 "f83681f6abcdf47721ed6a8af9d6e2a17219808bd08f7951c4c145920e9fdf94" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "serd"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    path = testpath/"input.ttl"
    path.write <<~EOS
      @prefix : <http://example.org/base#> .
      :a :b :c .
    EOS

    output = "<http://example.org/base#a> <http://example.org/base#b> <http://example.org/base#c> .\n"
    assert_equal output, shell_output(bin/"sordi input.ttl")
  end
end
