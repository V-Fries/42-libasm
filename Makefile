BUILD_ROOT			=	.build/
NAME				=	libasm.a
NAME_BONUS			=	libasm_bonus.a

include src.mk
SRC_PATH			=	src/
OBJS				=	$(patsubst %.s, $(BUILD_ROOT)%.o, $(SRC))
DEPS				=	$(patsubst %.s, $(BUILD_ROOT)%.o.d, $(SRC))


OBJS_BONUS			=	$(patsubst %.s, $(BUILD_ROOT)%.o, $(SRC_BONUS))
DEPS_BONUS			=	$(patsubst %.s, $(BUILD_ROOT)%.o.d, $(SRC_BONUS))

DIR_INCLUDES		=	include/
INCLUDES			=	$(addprefix -I , $(DIR_INCLUDES))

RM					=	rm -rf
NASM				=	nasm 
DEPS_FLAGS			=	-MD -MP
NASM_FLAGS			=	-f elf64 -Werror -Wall $(DEPS_FLAGS) $(INCLUDES)
AR					=	ar rcs


.PHONY:	all
all:	$(NAME)

.PHONY: bonus
bonus: $(NAME_BONUS)

.PHONY: test
test:	bonus
	cd tests && RUSTFLAGS=-Zsanitizer=address cargo +nightly test -- --nocapture


$(NAME):	$(OBJS)
		$(RM) $(NAME)
		$(AR) $(NAME) $(OBJS)

$(NAME_BONUS): $(OBJS) $(OBJS_BONUS)
		$(RM) $(NAME_BONUS)
		$(AR) $(NAME_BONUS) $(OBJS) $(OBJS_BONUS)

.PHONY:	clean
clean:
		$(RM) $(BUILD_ROOT)

.PHONY:	fclean
fclean:	clean
		$(RM) $(NAME)
		$(RM) $(NAME_BONUS)

.PHONY:	re
re:		fclean
		$(MAKE) all

.PHONY:	re_bonus
re_bonus:		fclean
		$(MAKE) bonus

.PHONY:	re_test
re_test:	fclean
		$(MAKE) test

-include $(DEPS)
$(BUILD_ROOT)%.o : $(SRC_PATH)%.s
		@mkdir -p $(shell dirname $@)
		$(NASM) $(NASM_FLAGS) $< -o $@
