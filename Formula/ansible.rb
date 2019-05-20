class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.8.0.tar.gz"
  sha256 "7234dd7d89150dc5bf035bc1ec3c084a8a0699d89e1c9b06b2af6dd34b2ef3ae"
  revision 1
  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    cellar :any
    sha256 "00e23f61961a56de5c30750cee58b7a2e9692b020a22b8018b6e280e6616c593" => :mojave
    sha256 "3297446f73573f6b9800369daae17c370c4f87efe29e3f4f0f320f00f3d7998f" => :high_sierra
    sha256 "25ad717fc03c47ae3ad2aeb3501656a225cc57a77bf9dbc440384cce172a5a26" => :sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "ansible"
    venv.pip_install_and_link buildpath
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOS
    (testpath/"hosts.ini").write "localhost ansible_connection=local\n"
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"
  end
end
