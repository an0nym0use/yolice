module Yolice

  class SorensenIndex

    class << self
      def index(first_string, second_string)
        @first_bigram_set = bigrams_for(first_string)
        @second_bigram_set = bigrams_for(second_string)

        calculate
      end

      protected

      def calculate
        2 * similarity_count.to_f / total.to_f
      end

      def bigrams_for(str)
        str.downcase.to_enum(:each_char).each_cons(2).to_a
      end

      def similarity_count
        (@first_bigram_set & @second_bigram_set).count
      end

      def total
        @first_bigram_set.count + @second_bigram_set.count
      end
    end

  end

end
