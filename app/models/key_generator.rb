class KeyGenerator
  def self.generate(unique_id)
    unique_id =- 1
    available = []
    available << ("A".."Z").map
    available << ("a".."z").map
    available << ("0".."9").map

    available.flatten!
    result = ""

    code_length = 1
    cached_result = unique_id

    while (cached_result/available.length.to_f) >= 1
      code_length += 1
      cached_result = cached_result/available.length.to_f
    end

    while code_length > 0
      idx = (unique_id/(available.length**(code_length - 1))).to_i % available.length
      result << available[idx]
      code_length -= 1
    end

    result
  end
end
