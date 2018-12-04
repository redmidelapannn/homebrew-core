class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-2.9.6.tar.gz"
  sha256 "17cf76943de272fd579ed831a1fd85339b393f8d00bf9e0d17c91e972f583343"
  revision 1

  bottle do
    cellar :any
    sha256 "2794b4253a2c4296150ad9dbfb36583dd72394ae3a1634f8c6d5d61b91e616ee" => :mojave
    sha256 "18fb9f7167e588a9b37a3ec6cd89aefee936761a01f895324f56a16c06a4ff06" => :high_sierra
    sha256 "25ac6d50f96d81c90af7fd14579ef76eba7c57a5806e189310611fb139cb6792" => :sierra
  end

  depends_on "gettext"

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-words-2.9.6.bz2"
    sha256 "460307bb9b46dfd5068d62178285ac2f70279e64b968972fe96f5ed07adc1a77"
  end

  # Upstream commit from 25 Aug 2016 "Apply patch to fix CVE-2016-6318"
  patch :p2 do
    url "https://github.com/cracklib/cracklib/commit/47e5dec.patch?full_index=1"
    sha256 "7b3604d503208365951038b04990eef24b8ef90ce845fd84e2d2ab88a9a4f56b"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words"
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var/"cracklib").mkpath
    cp share/"cracklib-words-#{version}", var/"cracklib/cracklib-words"
    system "#{bin}/cracklib-packer < #{var}/cracklib/cracklib-words"
  end

  test do
    assert_match /password: it is based on a dictionary word/, pipe_output("#{bin}/cracklib-check", "password", 0)
  end
end
