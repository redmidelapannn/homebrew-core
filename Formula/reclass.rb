class Reclass < Formula
  desc "Recursive external node classification"
  homepage "https://reclass.pantsfullofunix.net/"
  url "https://github.com/madduck/reclass/archive/reclass-1.4.1.tar.gz"
  sha256 "48271fcd3b37d8945047ed70c478b387f87ffef2fd209fe028761724ed2f97fb"
  head "https://github.com/madduck/reclass.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "3f239f7f90855c294ae39e3cf5cb7d557a4c4781ee0360c7717256df29120f86" => :high_sierra
    sha256 "83fce88afdd9f1c68ed2ce9ccbadc9359f986d0a460607871b922293c89c9b0f" => :sierra
    sha256 "c37b58c43a52f374eefe2708009ba3c60d2582852ed1f4e4af1e76e12b2084c4" => :el_capitan
  end

  depends_on "python@2"

  def install
    ENV.prepend_create_path "PYTHONPATH", "#{libexec}/lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/reclass", "--version"
  end
end
