class Honcho < Formula
  desc "Python clone of Foreman, for managing Procfile-based applications"
  homepage "https://github.com/nickstenning/honcho"
  url "https://github.com/nickstenning/honcho/archive/v1.0.1.tar.gz"
  sha256 "3271f986ff7c4732cfd390383078bfce68c46f9ad74f1804c1b0fc6283b13f7e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "eb1ec7d70400f69c92ac15064b8e443876c4226ed8f3c324b5aede6bdbf5c75c" => :high_sierra
    sha256 "eb1ec7d70400f69c92ac15064b8e443876c4226ed8f3c324b5aede6bdbf5c75c" => :sierra
    sha256 "eb1ec7d70400f69c92ac15064b8e443876c4226ed8f3c324b5aede6bdbf5c75c" => :el_capitan
  end

  depends_on "python@2"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"Procfile").write("talk: echo $MY_VAR")
    (testpath/".env").write("MY_VAR=hi")
    assert_match /talk\.\d+ \| hi/, shell_output("#{bin}/honcho start")
  end
end
