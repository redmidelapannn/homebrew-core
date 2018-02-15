class Reclass < Formula
  desc "Recursive external node classification"
  homepage "https://reclass.pantsfullofunix.net/"
  url "https://github.com/madduck/reclass/archive/reclass-1.4.1.tar.gz"
  sha256 "48271fcd3b37d8945047ed70c478b387f87ffef2fd209fe028761724ed2f97fb"
  head "https://github.com/madduck/reclass.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "23c8cefd13f93b29d2a5437dfa97cf46f809538edeca63eb9f7db6df1962dbea" => :high_sierra
    sha256 "92daf35bb095c96024c69567cbb163aa738f0d0dc3ea81f779dc330df45f0f21" => :sierra
    sha256 "ccea1563b816a70e9f806d8c5a490d8bf2955777d7406f25398079327088e131" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
