class Twvpn < Formula
  desc "This is a tool for thoughtworks to connect vpn"
  homepage "https://github.com/bangwu/twvpn"
  url "https://github.com/bangwu/twvpn/archive/1.0.1.tar.gz"
  sha256 "5a6bc9a5626ac1421be5a681eb60625980f48f89d4c4d575787f2729132b9bab"
  head "https://github.com/bangwu/twvpn.git"
  bottle do
    cellar :any_skip_relocation
    sha256 "34493ae942feb7dd6a883f6af70825b2962b7aa6b4031959b2e4433030b0ef33" => :mojave
    sha256 "c05f9a82a4161f3bf40e7d6421b83dd6e92e4068043c5957b718ad8ca66a7b83" => :high_sierra
    sha256 "c05f9a82a4161f3bf40e7d6421b83dd6e92e4068043c5957b718ad8ca66a7b83" => :sierra
  end

  depends_on "oath-toolkit"

  def install
    bin.install "twvpn.sh" => "twvpn"
  end

  def caveats; <<~EOS
    Please use the below command to update you info, so that you can connect you vpn.
      security add-generic-password -U -a auth_code -s playground -w you_auth_code
      security add-generic-password -U -a vpn_url -s playground -w you_vpn_url
      security add-generic-password -U -a user_name -s playground -w you_name
      security add-generic-password -U -a password -s playground -w you_password
      security add-generic-password -U -a validate_type -s playground -w you_validate_type
    You should add a config info into the keychain
  EOS
  end

  test do
    system "false"
  end
end
