# frozen_string_literal: true

require "helper"

class TestPathManager < JekyllUnitTest
  context "PathManager" do
    setup do
      @source = Dir.pwd
    end

    should "return frozen copy of base if questionable path is nil" do
      assert_equal @source, Jekyll::PathManager.sanitized_path(@source, nil)
      assert Jekyll::PathManager.sanitized_path(@source, nil).frozen?
    end

    should "return a frozen copy of base if questionable path expands into the base" do
      assert_equal @source, Jekyll::PathManager.sanitized_path(@source, File.join(@source, "/"))
      assert Jekyll::PathManager.sanitized_path(@source, File.join(@source, "/")).frozen?
    end

    should "return a frozen string result" do
      if Jekyll::Utils::Platforms.really_windows?
        assert_equal(
          "#{@source}/_config.yml",
          Jekyll::PathManager.sanitized_path(@source, "E:\\_config.yml")
        )
      end
      assert_equal(
        "#{@source}/_config.yml",
        Jekyll::PathManager.sanitized_path(@source, "//_config.yml")
      )
      assert Jekyll::PathManager.sanitized_path(@source, "//_config.yml").frozen?
    end
    
    context "security features" do
      should "block directory traversal attempts with ../" do
        malicious_paths = [
          "../../../etc/passwd",
          "../../secret.txt",
          "path/../../../etc/passwd",
          "valid/path/../../../../../../etc/passwd"
        ]
        
        malicious_paths.each do |path|
          result = Jekyll::PathManager.sanitized_path(@source, path)
          assert_equal @source, result, "Failed to block traversal attempt: #{path}"
          assert result.frozen?
        end
      end
      
      should "block directory traversal attempts with backslashes" do
        malicious_paths = [
          "..\\..\\..\\windows\\system32",
          "..\\secret.txt",
          "path\\..\\..\\..\\windows\\system32"
        ]
        
        malicious_paths.each do |path|
          result = Jekyll::PathManager.sanitized_path(@source, path)
          assert_equal @source, result, "Failed to block traversal attempt: #{path}"
          assert result.frozen?
        end
      end
      
      should "block URL encoded directory traversal attempts" do
        malicious_paths = [
          "%2e%2e%2f%2e%2e%2fetc%2fpasswd",
          "%2e%2e%2fsecret.txt",
          "path/%2e%2e/%2e%2e/etc/passwd",
          "%2E%2E%2F%2E%2E%2Fetc%2Fpasswd"  # Mixed case
        ]
        
        malicious_paths.each do |path|
          result = Jekyll::PathManager.sanitized_path(@source, path)
          assert_equal @source, result, "Failed to block URL encoded traversal: #{path}"
          assert result.frozen?
        end
      end
      
      should "block hex encoded directory traversal attempts" do
        malicious_paths = [
          "\x2e\x2e/\x2e\x2e/etc/passwd",
          "\x2e\x2e/secret.txt"
        ]
        
        malicious_paths.each do |path|
          result = Jekyll::PathManager.sanitized_path(@source, path)
          assert_equal @source, result, "Failed to block hex encoded traversal: #{path}"
          assert result.frozen?
        end
      end
      
      should "block paths ending with directory traversal" do
        malicious_paths = [
          "some/path/..",
          "some/path\\..",
          "path/to/directory/../.."
        ]
        
        malicious_paths.each do |path|
          result = Jekyll::PathManager.sanitized_path(@source, path)
          assert_equal @source, result, "Failed to block path ending with traversal: #{path}"
          assert result.frozen?
        end
      end
      
      should "allow legitimate paths without directory traversal" do
        safe_paths = [
          "_posts/2023-01-01-hello.md",
          "assets/css/style.css",
          "_includes/header.html",
          "path/to/file.txt",
          "file..txt",  # Double dots in filename are OK
          "my...file.txt"  # Multiple dots in filename are OK
        ]
        
        safe_paths.each do |path|
          result = Jekyll::PathManager.sanitized_path(@source, path)
          expected = File.join(@source, path)
          assert_equal expected, result, "Incorrectly blocked safe path: #{path}"
          assert result.frozen?
        end
      end
    end
    
    context "Windows path handling" do
      should "properly sanitize Windows drive letters" do
        if Jekyll::Utils::Platforms.really_windows?
          # Test UNC path preservation
          unc_path = "//server/share/file.txt"
          result = Jekyll::PathManager.sanitized_path(@source, unc_path)
          assert result.include?("server/share/file.txt")
          
          # Test drive letter removal
          drive_path = "C:/users/test/file.txt"
          result = Jekyll::PathManager.sanitized_path(@source, drive_path)
          assert !result.start_with?("C:")
        else
          # On non-Windows, drive letters should still be removed
          drive_path = "C:/users/test/file.txt"
          result = Jekyll::PathManager.sanitized_path(@source, drive_path)
          assert !result.include?("C:")
        end
      end
    end
    
    context "caching behavior" do
      should "return the same frozen object for repeated calls" do
        path = "_posts/test.md"
        
        result1 = Jekyll::PathManager.sanitized_path(@source, path)
        result2 = Jekyll::PathManager.sanitized_path(@source, path)
        
        assert_equal result1.object_id, result2.object_id, "Should return cached result"
        assert result1.frozen? && result2.frozen?
      end
      
      should "cache join operations" do
        base = "path/to"
        item = "file.txt"
        
        result1 = Jekyll::PathManager.join(base, item)
        result2 = Jekyll::PathManager.join(base, item)
        
        assert_equal result1.object_id, result2.object_id, "Should return cached join result"
        assert result1.frozen? && result2.frozen?
      end
    end
  end
end
