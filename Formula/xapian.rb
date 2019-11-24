class Xapian < Formula
  desc "C++ search engine library"
  homepage "https://xapian.org/"
  url "https://oligarchy.co.uk/xapian/1.4.13/xapian-core-1.4.13.tar.xz"
  sha256 "93f8ffffa80c5e6036befbf356f34456cc18c2f745cef85e9b4cfc254042137c"
  revision 1
  version_scheme 1

  bottle do
    cellar :any
    sha256 "ee5372b8733573a6b0cf15b6c55874db89340093189e97da4a1283a81d309951" => :mojave
    sha256 "a3a250894cb931b362a63e53805ba74d0df4399191dd8b492092aef269a95577" => :high_sierra
  end

  depends_on "sphinx-doc" => :build
  depends_on "python"

  skip_clean :la

  resource "bindings" do
    url "https://oligarchy.co.uk/xapian/1.4.13/xapian-bindings-1.4.13.tar.xz"
    sha256 "7a5a5d2712159ed0a5174a8aabedfc01452a69ebd6e2147d97e497122baa5892"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    resource("bindings").stage do
      ENV["XAPIAN_CONFIG"] = bin/"xapian-config"
      xy = Language::Python.major_minor_version "python3"
      ENV.prepend_create_path "PYTHON3_LIB", lib/"python#{xy}/site-packages"

      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"lib/python#{xy}/site-packages"
      ENV.append_path "PYTHONPATH", Formula["sphinx-doc"].opt_libexec/"vendor/lib/python#{xy}/site-packages"

      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-python3"

      system "make", "install"
    end
  end

  test do
    system bin/"xapian-config", "--libs"
    system "python3 -c 'import xapian'"
  end
end
