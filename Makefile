BUILD_ROOT			=	.build/
NAME				=	libasm.a

include src.mk
SRC_PATH			=	src/
OBJS				=	$(patsubst %.s, $(BUILD_ROOT)%.o, $(SRC))

RM					=	rm -rf
NASM				=	nasm -f elf64 -Werror -Wall
AR					=	ar rcs

# TODO recompile on dependency change

.PHONY:	all
all:	$(NAME)

.PHONY: test
test:	all
	cd tests && cargo test --release -- --nocapture


$(NAME):	$(OBJS)
		$(RM) $(NAME)
		$(AR) $(NAME) $(OBJS)

.PHONY:	clean
clean:
		$(RM) $(BUILD_ROOT)

.PHONY:	fclean
fclean:	clean
		$(RM) $(NAME)

.PHONY:	re
re:		fclean
		$(MAKE) all

.PHONY:	re_test
re_test:	fclean
		$(MAKE) test

$(BUILD_ROOT)%.o : $(SRC_PATH)%.s
		@mkdir -p $(shell dirname $@)
		$(NASM) $< -o $@
