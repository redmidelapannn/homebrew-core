class Tvnamer < Formula
  desc "Automatic TV episode file renamer that uses data from thetvdb.com"
  homepage "https://github.com/dbr/tvnamer"
  url "https://github.com/dbr/tvnamer/archive/2.3.tar.gz"
  sha256 "c28836f4c9263ee8ad6994788ad35f00e66fa1bd602e876364cd9b938f2843c8"
  head "https://github.com/dbr/tvnamer.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d77db18284c5fb54c5c635e97cc2e7c1019d151a8b55f9a13e9eccae05e77941" => :el_capitan
    sha256 "52ee01e7494eb4a31b3699127627f63459133cc8d1931ac4147868bc57588497" => :yosemite
    sha256 "c9d1fe1dc438c04edd6a1617dfc4b614957ed381f4f849094d19e31fa5a37eb5" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "tvdb_api" do
    url "https://pypi.python.org/packages/source/t/tvdb_api/tvdb_api-1.10.tar.gz"
    sha256 "308e73a16fc79936f1bf5a91233cce6ba5395b3f908ac159068ce7b1fc410843"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[tvdb_api].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    raw_file = "brass.eye.s01e01.avi"
    expected_file = "Brass Eye - [01x01] - Animals.avi"
    touch testpath/raw_file
    system bin/"tvnamer", "-b", testpath/raw_file
    File.exist? testpath/expected_file
  end
end
