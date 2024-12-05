BUILD_ROOT			=	.build/
NAME				=	libasm.a

include src.mk
SRC_PATH			=	src/
OBJS				=	$(patsubst %.s, $(BUILD_ROOT)%.o, $(SRC))
DEPS				=	$(patsubst %.s, $(BUILD_ROOT)%.o.d, $(SRC))

DIR_INCLUDES		=	include/
INCLUDES			=	$(addprefix -I , $(DIR_INCLUDES))

RM					=	rm -rf
NASM				=	nasm 
DEPS_FLAGS			=	-MD -MP
NASM_FLAGS			=	-f elf64 -Werror -Wall -gdwarf $(DEPS_FLAGS) $(INCLUDES)
AR					=	ar rcs


.PHONY:	all
all:	$(NAME)

.PHONY: test
test:	all
	cd tests && RUSTFLAGS=-Zsanitizer=address cargo +nightly test -- --nocapture


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

-include $(DEPS)
$(BUILD_ROOT)%.o : $(SRC_PATH)%.s
		@mkdir -p $(shell dirname $@)
		$(NASM) $(NASM_FLAGS) $< -o $@
