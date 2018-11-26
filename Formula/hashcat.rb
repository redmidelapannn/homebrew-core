class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  # Note the mirror will return 301 until the version becomes outdated.
  url "https://github.com/hashcat/hashcat.git", :using => :git, :tag => "v5.0.0", :revision => "915da5fee336a5cdf5c1ec88fc66f29b7fdaf45d"
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git"

  bottle do
    sha256 "c9111b4f7d66bede73cc973e52b2280f97cee023993d64a5440186bb365d5c8b" => :mojave
    sha256 "033ba0018c15ed976d3373e9b0703efef2608e675cf128b77b13dac896fc4330" => :high_sierra
    sha256 "2c577e2f45d677ef7a140b93724e15842fbf40cfa1170fd95bc389eb78afe8b5" => :sierra
  end

  depends_on "gnu-sed" => :build

  # Upstream could not fix OpenCL issue on Mavericks.
  # https://github.com/hashcat/hashcat/issues/366
  # https://github.com/Homebrew/homebrew-core/pull/4395
  depends_on :macos => :yosemite

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end

  test do
    #
    # General test settings
    #

    binary    = "./hashcat"
    pass      = "hash234"
    hash_type = "500" # -m 500 = md5crypt, MD5(Unix), FreeBSD MD5, Cisco-IOS MD5

    dict_file = "example.dict"
    hash_file = "example#{hash_type}.hash"

    additional_args = " --force" +                  # shouldn't be needed with a correct OpenCL installation
                      " --quiet" +                  # we only need the hash:pass pair in the output
                      " --potfile-disable" +        # we do not need to check or write the hashcat.potfile
                      " --optimized-kernel-enable"  # enable optimizations (assumes passwords are short)

    #
    # Copy some files to the test folder
    #

    # copy all files from share to the test folder
    cp_r pkgshare.children, testpath

    # copy the example hash and the dictionary file to the test folder
    cp "#{doc}/#{hash_file}", testpath
    cp "#{doc}/#{dict_file}", testpath

    # copy the hashcat binary to the test folder
    cp "#{bin}/#{binary}", testpath

    #
    # Test 1 (dictionary attack, -a 0):
    #

    hash = File.open(hash_file, "rb") { |f| f.read.strip }

    attack_mode = "0"

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + dict_file

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 2 (combinator attack, -a 1):
    #

    attack_mode = "1"

    dict1 = "dict1.txt"
    dict2 = "dict2.txt"

    File.write(dict1, pass[0..3])
    File.write(dict2, pass[4..-1])

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + dict1 + " " + dict2

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 3 (mask attack, -a 3):
    #

    attack_mode = "3"

    mask = "?l?l?l" + pass[3..-1]

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + mask

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 4 (hybrid attack, dict + mask, -a 6):
    #

    attack_mode = "6"

    mask = "?d?d?d"

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + dict1 + " " + mask

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip

    #
    # Test 5 (hybrid attack, mask + dict, -a 7):
    #

    attack_mode = "7"

    mask = "?l?l" + pass[2..3]

    cmd = binary + " -m " + hash_type + " -a " + attack_mode + additional_args + " " + hash_file + " " + mask + " " + dict2

    # suppress STDERR output
    cmd += " 2>/dev/null"

    assert_equal "#{hash}:#{pass}", shell_output(cmd).strip
  end
end
